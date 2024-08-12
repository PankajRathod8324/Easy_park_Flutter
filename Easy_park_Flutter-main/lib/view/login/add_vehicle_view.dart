import 'dart:convert';

import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/line_text_field.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddVehicleView extends StatefulWidget {
  const AddVehicleView({Key? key}) : super(key: key);

  @override
  State<AddVehicleView> createState() => _AddVehicleViewState();
}

class _AddVehicleViewState extends State<AddVehicleView> {
  TextEditingController txtBrandName = TextEditingController();
  TextEditingController txtModelName = TextEditingController();
  TextEditingController txtNumberPlate = TextEditingController();
  TextEditingController txtSeries = TextEditingController();
  String selectedSeat = '4 Wheeler';

  List brandArr = [];
  List seriesArr = [];

  Map? selectBrandObj;
  Map? selectSeriesObj;

  int otherFlag = 0;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 25,
            height: 25,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Vehicle",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              LineTextField(
                title: "Brand",
                hintText: "Enter Brand",
                controller: txtBrandName,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Enter Series",
                hintText: "X1",
                controller: txtSeries,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Number Plate",
                hintText: "YT12345",
                controller: txtNumberPlate,
              ),
              const SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  showSeatSelectionDialog();
                },
                child: TextField(
                  enabled: false,
                  controller: TextEditingController(text: selectedSeat),
                  decoration: InputDecoration(
                    labelText: "Seat",
                    hintText: "Select Seat",
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              RoundButton(
                onPressed: () {
                  // Call the method to send data to the backend
                  sendVehicleDetailsToBackend();
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
        ),
      ),
    );
  }

  Future<void> showSeatSelectionDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Seat Type"),
          content: Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedSeat = '4 Wheeler';
                  });
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  title: Text("4 Wheeler"),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedSeat = '6 Wheeler';
                  });
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  title: Text("6 Wheeler"),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedSeat = 'Truck';
                  });
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  title: Text("Truck"),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedSeat = 'Mini Truck';
                  });
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  title: Text("Mini Truck"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void sendVehicleDetailsToBackend() async {
    final String brand = txtBrandName.text;
    final String model = txtSeries.text;
    final String numberPlate = txtNumberPlate.text;
    final String seating = selectedSeat;

    // Check if any of the required fields are empty
    if (brand.isEmpty ||
        model.isEmpty ||
        numberPlate.isEmpty ||
        seating.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all the required fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userEmail = prefs.getString('userEmail');

<<<<<<< HEAD
    String? vehicleObjectId = prefs.getString('vehicleObjectId');
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    Map<String, dynamic> allPrefs = prefs1.getKeys().fold<Map<String, dynamic>>(
      {},
      (Map<String, dynamic> acc, String key) {
        acc[key] = prefs1.get(key);
        return acc;
      },
    );

    try {
      print('Vehicle Data:');
      print('Brand: $brand');
      print('Model: $model');
      print('Number Plate: $numberPlate');
      print('Seating: $seating');
      print('User Email: $userEmail');
      print('Vehicle Object ID: $vehicleObjectId');
=======
    try {
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
      final response = await http.post(
        Uri.parse(addVehicle),
        body: {
          'userEmail': userEmail,
          'vehicleData': json.encode({
            'brand': brand,
            'model': model,
            'seating': seating, // Assuming seating is an integer
            'numberPlate': numberPlate,
          }),
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200 || response.statusCode == 201) {
<<<<<<< HEAD
        print('--------------------------------------------------');
        print(userEmail);
        print('-------------------------------------------------');
        // Assuming you have stored the vehicle object ID in shared preferences
        print(vehicleObjectId);
        print('Add Successfully');
        print(allPrefs);

=======
        print('Add Successfully');
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
        Fluttertoast.showToast(
          msg: 'Vehicle added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
<<<<<<< HEAD
      } else if (response.statusCode == 409) {
        // Check if the status code is 409 (Conflict)
        print('Number plate already used');
        Fluttertoast.showToast(
          msg: 'Number plate already used',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        print('Add failed. Status code: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'NUmber Plate Is already Used.',
=======
      } else {
        print('Add failed. Status code: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'Add failed. Please check your input and try again.',
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error during add: $e');
    }
  }
}
