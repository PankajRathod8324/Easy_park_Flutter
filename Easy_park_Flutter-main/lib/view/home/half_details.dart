import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:easy_park_app/view/home/full_details.dart';
import 'package:easy_park_app/view/menu/menu_view.dart';
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
      home: HalfDetailsView()
    );
  }
}

class HalfDetailsView extends StatefulWidget {
  // const HalfDetailsView({Key? key}) : super(key: key);
  // final ParkAreaDetails parkAreaDetails;

  const HalfDetailsView({Key? key}) : super(key: key);


  @override
  State<HalfDetailsView> createState() => _HalfDetailsViewState();
}

class _HalfDetailsViewState extends State<HalfDetailsView> {
  int selected = 0;
  final controller = PageController();

  String address = '';
  String postalCode = '';
  final Completer<GoogleMapController> _controller = Completer();

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
      infoWindow: InfoWindow(title: 'some Info '),
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

  loadData() {
    _getUserCurrentLocation().then((value) async {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(value.latitude, value.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          postalCode = placemark.postalCode ?? ''; // Get the postal code
        });
      }
      _markers.add(Marker(
        markerId: const MarkerId('2'),
        position: LatLng(value.latitude, value.longitude),
        infoWindow: InfoWindow(title: 'current location'),
      ));

      _circles.add(Circle(
        circleId: CircleId('circle'),
        center: LatLng(value.latitude, value.longitude),
        radius: 700,
        strokeWidth: 2,
        strokeColor: Colors.blue,
        fillColor: Colors.blue.withOpacity(0.1),
      ));

      final GoogleMapController controller = await _controller.future;
      CameraPosition _kGooglePlex = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );
      controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

      // Create 5 random markers within the circle area
      for (int i = 0; i < 5; i++) {
        double angle = random.nextDouble() * 2 * pi;
        double radius = random.nextDouble() * 700; // Radius within the circle

        double lat = value.latitude + radius * cos(angle);
        double lng = value.longitude + radius * sin(angle);

        // Check if the random point is within the circle
        double distanceToCenter = Geolocator.distanceBetween(
            value.latitude, value.longitude, lat, lng);
        if (distanceToCenter <= 700) {
          _markers.add(Marker(
            markerId: MarkerId('RandomMarker$i'),
            position: LatLng(lat, lng),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: InfoWindow(title: 'Random Marker $i'),
          ));
        } else {
          // If the marker is outside the circle, decrease the counter to try again
          i--;
        }
      }
      print(postalCode);
      setState(() {});
    });
  }

  // Function to handle marker tap
  void _onMarkerTapped(MarkerId markerId) {
    // Find the tapped marker using the markerId
    Marker tappedMarker =
        _markers.firstWhere((marker) => marker.markerId == markerId);

    // Check if the tapped marker is not the user's location marker
    if (tappedMarker.markerId.value != '1') {
      if (tappedMarker.markerId.value == '2') {
        // Handle the tap on the user's location marker (markerId 'SomeId')
        // You can replace the following line with your navigation logic
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => MenuView()));
      } else {
        // Clear existing polyline
        polylineCoordinates.clear();

        // Add the user's location and tapped marker positions to the polyline
        LatLng userLocation = _markers[1].position;
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
                // Additional widgets if needed
              ],
            ),
          ),
          // Half detail screen
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  // Image if available
                  // imageUrl.isNotEmpty
                  //     ? Image.network(
                  //         imageUrl,
                  //         width: double.infinity,
                  //         height: MediaQuery.of(context).size.height * 0.26,
                  //         fit: BoxFit.cover,
                  //       )
                  //     : Container(), // Show nothing if imageUrl is empty
                  // SizedBox(height: 16),
                  // // Show owner name
                  // Text(
                  //   "Owner Name: $ownerName",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // // Show image URL
                  // Text(
                  //   "Image URL: $imageUrl",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
                  // Text(
                  //   "Details",
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  // SizedBox(height: 16),
                  // Image
                  // Container(
                  //   width: double.infinity,
                  //   height: MediaQuery.of(context).size.height * 0.26,
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(20),
                  //     image: DecorationImage(
                  //       image: AssetImage("assets/img/deatils.png"),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                  // Spacer
                  // SizedBox(height: 16),
                  // Container(
                  //   padding: EdgeInsets.all(8),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(
                  //         color: const Color.fromARGB(255, 146, 136, 136)),
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Text(
                  //         "Parking Lot of San Manolia",
                  //         style: TextStyle(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       Spacer(), // Add space between text and icon
                  //       Icon(Icons.bookmark_border,
                  //           color: Colors.black), // Saved icon
                  //     ],
                  //   ),
                  // ),
                  // Saved icon
                  // Cancel and Details buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle cancel button press
                          Navigator.of(context)
                              .pop(); // This will pop the HalfDetailsView page, bringing you back to the previous page (Home in this case)
                        },
                        child: Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Handle details button press
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => FullDetailsScreen()));
                        },
                        child: Text('Details'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // SafeArea, Row, and Stack widgets remain unchanged
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 60,
                      ),
                      SizedBox(
                        width: 60,
                        child: Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            InkWell(
                              onTap: () {
                                // context.push(const MenuView());
                              },
                              child: Container(
                                margin: const EdgeInsets.only(top: 30),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: SvgPicture.asset(
                                    "assets/img/search.svg",
                                    width: 25,
                                    height: 25,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected,
        unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
        selectedItemColor: Colors.green,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.house_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border_rounded), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.style_outlined), label: 'Style'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == selected) return;
          if (index == 3) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => MenuView()));
          } else {
            controller.jumpToPage(index);
            setState(() {
              selected = index;
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
