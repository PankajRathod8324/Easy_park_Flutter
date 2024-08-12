import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_park_app/view/login/add_vehicle_view.dart';
import 'package:easy_park_app/view/config/config.dart';

class MyVehicleView extends StatefulWidget {
  const MyVehicleView({Key? key}) : super(key: key);

  @override
  _MyVehicleViewState createState() => _MyVehicleViewState();
}

class _MyVehicleViewState extends State<MyVehicleView> {
  List<Map<String, dynamic>> vehicleList = [];
  late String userEmail;
  int? selectedVehicleId;
  ImageProvider imageProvider =
      AssetImage("assets/img/img_kisspng_2017_te.png");

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
          'My Vehicle',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: vehicleList.length,
                    itemBuilder: (context, index) {
                      var vehicle = vehicleList[index];
                      return TextButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          // Store the ID of the selected car in local storage
                          prefs.setInt('selectedVehicleId', vehicle['id']);

                          setState(() {
                            selectedVehicleId = vehicle['id'];
                          });
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateColor.resolveWith(
                              (states) => Colors.transparent),
                        ),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedVehicleId == vehicle['id']
                                  ? Colors
                                      .pink // Change color based on selection
                                  : Colors.grey.withOpacity(0.5),
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(width: 10.0),
                              Expanded(
                                child: Container(
                                  color: Colors.grey.withOpacity(0.1),
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vehicle['brand'] ?? 'Unknown Brand',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: selectedVehicleId ==
                                                  vehicle['id']
                                              ? Colors
                                                  .pink // Change color based on selection
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Model: ${vehicle['model'] ?? 'Unknown Model'}',
                                        style: TextStyle(
                                          color: selectedVehicleId ==
                                                  vehicle['id']
                                              ? Colors
                                                  .pink // Change color based on selection
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Seating: ${vehicle['seating'] ?? 'Unknown Seating'}',
                                        style: TextStyle(
                                          color: selectedVehicleId ==
                                                  vehicle['id']
                                              ? Colors
                                                  .pink // Change color based on selection
                                              : Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Number Plate: ${vehicle['numberPlate'] ?? 'Unknown Plate'}',
                                        style: TextStyle(
                                          color: selectedVehicleId ==
                                                  vehicle['id']
                                              ? Colors
                                                  .pink // Change color based on selection
                                              : Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  // SizedBox(height: 8),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     child: ElevatedButton(
                  //       onPressed: () async {
                  //         await Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => const AddVehicleView(),
                  //           ),
                  //         );
                  //         getCarsListApi();
                  //       },
                  //       child: Text('ADD A VEHICLE'),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          RoundButton(
            onPressed: () {
              // Call the method to send data to the backend
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddVehicleView()),
              );
            },
            title: "ADD VEHICLE",
          ),
          const SizedBox(
            height: 15,
          ),
          TextButton(
            onPressed: () {
              // Navigate to the home page without adding a vehicle
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeView()),
              );
            },
            child: Text(
              "SKIP",
              style: TextStyle(
                color: TColor.primaryText, // Adjust color as needed
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }
}
