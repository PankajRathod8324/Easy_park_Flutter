import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/login/add_vehicle_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MyVehicleView extends StatefulWidget {
  const MyVehicleView({Key? key}) : super(key: key);

  @override
  _MyVehicleViewState createState() => _MyVehicleViewState();
}

class _MyVehicleViewState extends State<MyVehicleView> {
  List<Map<String, dynamic>> vehicleList = [];
  late String userEmail;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('My Vehicles'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: vehicleList.length,
              itemBuilder: (context, index) {
                var vehicle = vehicleList[index];
                // Replace 'your_car_logo.png' with the actual image asset for the car logo
                var carLogo = Image.asset(
                  'assets/img/sm_my_vehicle.png',
                  width: 40.0,
                  height: 40.0,
                );

                return Card(
                  elevation: 2.0,
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                    // Remove the onTap property if you don't want to handle tap actions
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundButton(
              title: "ADD A VEHICLE",
              onPressed: () async {
                await context.push(const AddVehicleView());
                getCarsListApi();
              },
            ),
          ),
        ],
      ),
    );
  }
}
