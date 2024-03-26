import 'dart:async';
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
  final controller = PageController();
  late GoogleMapController mapController;
  late Marker moveableMarker;
  String address = '';

  @override
  void initState() {
    super.initState();
    moveableMarker = Marker(
      markerId: const MarkerId('moveableMarker'),
      position: const LatLng(21.1844, 72.8479),
      draggable: true,
      onDragEnd: (LatLng position) {
        _getAddress(position);
      },
    );
  }

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
        title: Text('Moveable Marker Demo'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: const LatLng(21.1844, 72.8479),
              zoom: 14,
            ),
            markers: Set.of([moveableMarker]),
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
