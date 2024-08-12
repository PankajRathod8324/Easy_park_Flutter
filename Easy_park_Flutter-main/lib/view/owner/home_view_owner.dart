import 'dart:async';
<<<<<<< HEAD
import 'package:easy_park_app/view/owner/addparkArea.dart';
import 'package:easy_park_app/view/owner/profile_owner.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
=======
import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/view/menu/menu_view.dart';
import 'package:easy_park_app/view/menu/my_profile_view.dart';
import 'package:easy_park_app/view/owner/addparkArea.dart';
import 'package:easy_park_app/view/home/vehicle.dart';
import 'package:easy_park_app/view/login/profileOwner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Moveable Marker Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const HomeViewOwner(),
    );
  }
}

class HomeViewOwner extends StatefulWidget {
  const HomeViewOwner({Key? key}) : super(key: key);

  @override
  State<HomeViewOwner> createState() => _HomeViewOwnerState();
}

class _HomeViewOwnerState extends State<HomeViewOwner> {
  int selected = 0;
<<<<<<< HEAD
  late GoogleMapController mapController;
  late Marker liveLocationMarker;
=======
  final controller = PageController();
  late GoogleMapController mapController;
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
  late Marker moveableMarker;
  String address = '';

  @override
  void initState() {
    super.initState();
<<<<<<< HEAD
    _getCurrentLocation();
    liveLocationMarker = Marker(
      markerId: const MarkerId('liveLocationMarker'),
      position: const LatLng(21.1844, 72.8479),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
    moveableMarker = Marker(
      markerId: const MarkerId('moveableMarker'),
      position: const LatLng(21.1844, 72.8479),
      draggable: true,
      onDragEnd: (LatLng position) {
        _getAddress(position);
      },
    );
  }

<<<<<<< HEAD
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        liveLocationMarker = Marker(
          markerId: const MarkerId('liveLocationMarker'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
        mapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14,
          ),
        ));
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
  Future<void> _getAddress(LatLng position) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks.first;
        setState(() {
          address =
              '${placemark.thoroughfare}, ${placemark.locality}, ${placemark.postalCode}';
        });
        print('Latitude: ${position.latitude}');
        print('Longitude: ${position.longitude}');
        print('Pincode: ${placemark.postalCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: const Text('Moveable Marker Demo'),
=======
        title: Text('Moveable Marker Demo'),
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
<<<<<<< HEAD
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
              zoom: 14,
            ),
            markers: Set.of([liveLocationMarker, moveableMarker]),
=======
            initialCameraPosition: CameraPosition(
              target: const LatLng(21.1844, 72.8479),
              zoom: 14,
            ),
            markers: Set.of([moveableMarker]),
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
            onTap: (LatLng latLng) {
              setState(() {
                moveableMarker = Marker(
                    markerId: const MarkerId('moveableMarker'),
                    position: latLng,
                    draggable: true,
                    onDragEnd: (LatLng position) {
                      _getAddress(position);
                    },
                    onTap: () {
                      // Open a new page when the marker is tapped
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddParkArea(position: latLng),
                      ));
                    });
              });
              _getAddress(latLng);
            },
          ),
          if (address.isNotEmpty)
            Positioned(
              top: 16.0,
              left: 16.0,
              child: Card(
                elevation: 4.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Latitude: ${moveableMarker.position.latitude}\nLongitude: ${moveableMarker.position.longitude}\nAddress: $address',
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selected,
<<<<<<< HEAD
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.house_outlined), label: 'Home'),
          BottomNavigationBarItem(
=======
        unselectedItemColor: Color.fromARGB(255, 0, 0, 0),
        selectedItemColor: TColor.primary,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.house_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.star_border_rounded), label: 'Favorites'),
          BottomNavigationBarItem(
              icon: Icon(Icons.style_outlined), label: 'Style'),
          BottomNavigationBarItem(
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == selected) return;
          if (index == 3) {
            Navigator.of(context)
<<<<<<< HEAD
                .push(MaterialPageRoute(builder: (context) => ProfileOwner()));
          } else {
=======
                .push(MaterialPageRoute(builder: (context) => MenuView()));
          } else {
            controller.jumpToPage(index);
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
