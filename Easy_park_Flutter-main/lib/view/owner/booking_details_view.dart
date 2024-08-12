import 'dart:convert';
import 'package:easy_park_app/view/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OwnerBookingDetailsPage extends StatefulWidget {
  OwnerBookingDetailsPage();

  @override
  _OwnerBookingDetailsPageState createState() =>
      _OwnerBookingDetailsPageState();
}

class _OwnerBookingDetailsPageState extends State<OwnerBookingDetailsPage> {
  late Future<Map<String, dynamic>> _ownerBookingDetails;
  late String ownerEmail = '';

  @override
  void initState() {
    super.initState();
    _ownerBookingDetails = fetchOwnerBookingDetails(ownerEmail);
  }

  Future<Map<String, dynamic>> fetchOwnerBookingDetails(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ownerEmail = prefs.getString('ownerEmail') ?? '';
    print("--------------------------");
    print(ownerEmail);
    final response =
        await http.get(Uri.parse('$getOwnerBookingDetails?email=$ownerEmail'));
    print('body-----------------------');
    print(response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load owner booking details');
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
          'Booking Deatails',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _ownerBookingDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildOwnerDetails(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget buildOwnerDetails(Map<String, dynamic> data) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Owner Booking Details'),
      ),
      body: ListView.builder(
        itemCount: data['bookingDetails'].length,
        itemBuilder: (context, index) {
          var booking = data['bookingDetails'][index];
          var parkAreaId = booking['parkArea'];
          var parkAreaDetails = data['ownerDetails']['parkingAreas'].firstWhere(
              (area) => area['_id'] == parkAreaId,
              orElse: () => {'name': 'Unknown'});

          return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Booking ID: ${booking['_id']}'),
                SizedBox(height: 5),
                Text(
                    'Vehicle Number Plate: ${getVehicleNumberPlate(booking['vehicle'], data)}'),
                SizedBox(height: 5),
                Text('Park Area: ${parkAreaDetails['name']}'),
                SizedBox(height: 5),
                Text('Start Time: ${booking['startTime']}'),
                SizedBox(height: 5),
                Text('End Time: ${booking['endTime']}'),
                SizedBox(height: 5),
                Text('Booking Date: ${booking['bookingDate']}'),
                SizedBox(height: 5),
                Text('Status: ${booking['status']}'),
                SizedBox(height: 5),
                Text('Total Price: ${booking['totalPrice']}'),
                SizedBox(height: 5),
                Text('Slot: ${booking['slot']}'),
              ],
            ),
          );
        },
      ),
    );
  }

  String getVehicleNumberPlate(String vehicleId, Map<String, dynamic> data) {
    var vehicleDetails = data['vehicleDetails'].firstWhere(
        (vehicle) => vehicle['_id'] == vehicleId,
        orElse: () => {'numberPlate': 'Unknown'});

    return vehicleDetails['numberPlate'];
  }
}
