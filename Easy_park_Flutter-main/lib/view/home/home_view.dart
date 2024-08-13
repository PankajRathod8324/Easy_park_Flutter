import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/home/full_details.dart';
import 'package:easy_park_app/view/home/display_json.dart';
import 'package:http/http.dart' as http;
import 'package:easy_park_app/common/color_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stylish Bottom Navigation Bar Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int selected = 0;
  final controller = PageController();
  late Map<String, dynamic> jsonData;

  String address = '';
  String postalCode = '';
  var parkAreas;
  var owner;
  final Completer<GoogleMapController> _controller = Completer();

  Future<void> _drawRoute(LatLng origin, LatLng destination) async {
    final apiKey = 'AIzaSyBPFQgA7MObBlTMV5Si-clGTpujKD_XBFA';
    final url = 'https://maps.googleapis.com/maps/api/directions/json?'
        'origin=${origin.latitude},${origin.longitude}&'
        'destination=${destination.latitude},${destination.longitude}&'
        'key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<LatLng> points =
          _decodePoly(data['routes'][0]['overview_polyline']['points']);

      setState(() {
        _polylines.add(Polyline(
          polylineId: const PolylineId('route'),
          points: points,
          color: Colors.blue,
          width: 5,
        ));
      });
    }
  }

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  final List<Marker> _markers = <Marker>[];
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> _polylines = Set<Polyline>();
  Random random = Random();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(33.6844, 73.0479),
    zoom: 14,
  );

  List<Marker> list = const [
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(33.6844, 73.0479),
      infoWindow: InfoWindow(title: 'Some Info'),
    ),
  ];

  // Create a PolylineId to uniquely identify the polyline
  PolylineId polylineId = PolylineId("polyline_id");
  List<LatLng> polylineCoordinates = []; // List to store polyline coordinates

  @override
  void initState() {
    super.initState();
    _markers.addAll(list);
    loadData();
  }

  loadData() async {
    Position position = await _getUserCurrentLocation();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks.first;
      setState(() {
        postalCode = placemark.postalCode ?? '';
      });
    }

    // Fetch data from the backend API based on latitude, longitude, and postal code
    final response = await http.get(
      Uri.parse(
          '$parkNearMe?latitude=${position.latitude}&longitude=${position.longitude}&postalCode=$postalCode'),
    );

    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      final parkAreas = jsonData['parkAreas'];
      final markersData = jsonData['markers'];

      for (var area in parkAreas) {
        double lat = area['location']['latitude'];
        double lng = area['location']['longitude'];
        _markers.add(Marker(
          markerId: MarkerId(lat.toString() + lng.toString()), // Use a unique ID for each marker
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: 'Park Area'),
        ));
      }

      for (var marker in markersData) {
        double lat = marker['latitude'];
        double lng = marker['longitude'];
        _markers.add(Marker(
          markerId: MarkerId(lat.toString() + lng.toString()), // Use a unique ID for each marker
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
          infoWindow: InfoWindow(title: 'Additional Marker'),
        ));
      }

      // Set the camera position to the current location
      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

      setState(() {});
    } else {
      // Handle error
      print('Failed to load data from the backend');
    }

    // Add the current location marker and circle
    _markers.add(Marker(
      markerId: const MarkerId('2'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(title: 'Current Location'),
    ));

    _circles.add(Circle(
      circleId: CircleId('circle'),
      center: LatLng(position.latitude, position.longitude),
      radius: 700,
      strokeWidth: 2,
      strokeColor: Colors.blue,
      fillColor: Colors.blue.withOpacity(0.1),
    ));

    setState(() {});
  }

  void _onMarkerTapped(MarkerId markerId) {
    // Find the tapped marker using the markerId
    Marker tappedMarker =
        _markers.firstWhere((marker) => marker.markerId == markerId);

    // Check if the tapped marker is not the user's location marker
    if (tappedMarker.markerId.value != '1') {
      if (tappedMarker.markerId.value == '2') {
        // Handle the tap on the user's location marker
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => DisplayJson(jsonData: jsonData),
        ));
      } else {
        // Clear existing polyline
        polylineCoordinates.clear();

        // Add the user's location and tapped marker positions to the polyline
        LatLng userLocation = _markers
            .firstWhere((marker) => marker.markerId.value == '2')
            .position;
        LatLng tappedMarkerLocation = tappedMarker.position;
        polylineCoordinates.add(userLocation);
        polylineCoordinates.add(tappedMarkerLocation);

        // Create the polyline
        Polyline polyline = Polyline(
          polylineId: polylineId,
          color: Colors.red,
          points: polylineCoordinates,
          width: 3,
        );

        // Add the polyline to the map
        setState(() {
          _polylines.clear(); // Clear existing polylines
          _polylines.add(polyline);
        });
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GoogleMap(
            initialCameraPosition: _kGooglePlex,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: Set<Marker>.of(_markers.map((marker) {
              return marker.copyWith(
                  onTapParam: () => _onMarkerTapped(marker.markerId));
            })),
            circles: _circles,
            polylines: _polylines, // Display the polyline on the map
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            onTap: (LatLng latLng) {
              // Clear existing polyline when the map is tapped
              setState(() {
                polylineCoordinates.clear();
                _polylines.clear();
              });
            },
          ),
          Container(
            height: MediaQuery.of(context).size.height * .2,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Add any additional widgets here
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<LatLng> _decodePoly(String encoded) {
    List<LatLng> poly = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index) - 63;
        index++;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLng(
        (lat / 1E5).toDouble(),
        (lng / 1E5).toDouble(),
      ));
    }

    return poly;
  }
}
