import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/home/book_parking_details.dart';
import 'package:easy_park_app/view/login/add_vehicle_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ChooseVehicleView extends StatefulWidget {
  final Map<String, dynamic>? matchingParkArea;
  final Map<String, dynamic> userData;
  const ChooseVehicleView(
      {Key? key, required this.matchingParkArea, required this.userData})
      : super(key: key);

  @override
  _ChooseVehicleViewState createState() => _ChooseVehicleViewState();
}

class _ChooseVehicleViewState extends State<ChooseVehicleView> {
  List<Map<String, dynamic>> vehicleList = [];
  late String userEmail;
  int? selectedVehicleIndex;

  Map<String, dynamic>? selectedVehicleData;

  @override
  void initState() {
    super.initState();
    getCarsListApi();
  }

  Future<void> getCarsListApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail') ?? '';
    try {
      var response = await http.get(
        Uri.parse('$getVehicle?userEmail=$userEmail'),
      );

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);

        print(jsonResponse);
        if (jsonResponse is Map && jsonResponse.containsKey('vehicles')) {
          // Check if the response is a map with 'vehicles' field
          vehicleList = List<Map<String, dynamic>>.from(
            jsonResponse['vehicles'] as List<dynamic>,
          );
        } else {
          // Handle the case where the response is not as expected
          vehicleList = [];
        }

        if (mounted) {
          setState(() {});
        }
      } else {
        // Handle the error if the HTTP request fails
        print('Failed to load vehicles. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any other errors that might occur during the API call
      print('Error during API call: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('----------------------------------===================');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Choose Your Vehicle',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: vehicleList.length,
              itemBuilder: (context, index) {
                var vehicle = vehicleList[index];
                var carLogo = Image.asset(
                  'assets/img/sm_my_vehicle.png',
                  width: 40.0,
                  height: 40.0,
                );

                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedVehicleIndex = index;
                      selectedVehicleData = vehicle;
                    });
                  },
                  child: Card(
                    elevation: 2.0,
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    color: selectedVehicleIndex == index
                        ? Colors.grey.withOpacity(0.5)
                        : null,
                    child: ListTile(
                      leading: carLogo,
                      title: Text(
                        vehicle['brand'] ?? '',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Model: ${vehicle['model'] ?? ''}'),
                          Text('Seating: ${vehicle['seating'] ?? ''}'),
                          Text('Number Plate: ${vehicle['numberPlate'] ?? ''}'),
                          // Add more details if needed
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundButton(
              title: "Continue",
              onPressed: () {
                if (selectedVehicleData != null) {
                  print('---------------------------------------');
                  print(selectedVehicleData);
                  print(widget.matchingParkArea);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookParkingPage(
                        vehicleData: selectedVehicleData!,
                        matchingParkArea: widget.matchingParkArea,
                        userData: widget.userData,
                      ),
                    ),
                  );
                } else {
                  // Show a message indicating that no vehicle is selected
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please select a vehicle.'),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundButton(
              title: "ADD A VEHICLE",
              onPressed: () async {
                await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddVehicleView()));
                getCarsListApi();
              },
            ),
          ),
        ],
      ),
    );
  }
}
