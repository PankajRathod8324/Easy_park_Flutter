import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/home/parking_ticket.dart';
import 'package:easy_park_app/view/login/add_vehicle_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ReviewSummaryView extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final Map<String, dynamic> vehicleData;
  final Map<String, dynamic>? matchingParkArea;
  final String selectedSpot;
  final String amount;
  final Map<String, dynamic> userData;
  const ReviewSummaryView(
      {super.key,
      required this.bookingData,
      required this.selectedSpot,
      required this.vehicleData,
      required this.matchingParkArea,
      required this.amount,
      required this.userData});

  @override
  _ReviewSummaryViewState createState() => _ReviewSummaryViewState();
}

class _ReviewSummaryViewState extends State<ReviewSummaryView> {
  late String address;
  late String vehicle;
  late String parkingspot;
  late String date;
  late String hours;
  late String amount;
  late String selectedSpot;
  @override
  void initState() {
    print(widget.bookingData);
    print(widget.matchingParkArea);
    print(widget.selectedSpot);
    print(widget.vehicleData);

    address = widget.matchingParkArea?['address'] ?? '';
    vehicle = widget.vehicleData['brand'] ?? '';
    parkingspot = widget.selectedSpot;
    date = widget.bookingData['bookingDate'];
    hours =
        widget.bookingData['startTime'] + " - " + widget.bookingData['endTime'];
    amount = widget.bookingData['totalPrice'].toString();
    super.initState();
  }

  Future<void> sendTicketDataToBackend(Map<String, dynamic> ticketData) async {
    try {
      var url = Uri.parse(bookparking); // Replace with your actual endpoint
      var response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(ticketData),
      );

      if (response.statusCode == 201) {
        // Ticket created successfully
        print('Ticket created successfully');
      } else {
        // Handle error
        print('Failed to create ticket. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error sending ticket data: $error');
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
          'Review Summary',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height *
                0.6, // Adjust the height as needed
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Parking Area:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        SizedBox(height: 8.0),
                        Text('Parking Lot of Los Angels',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        SizedBox(height: 16.0),
                        Text('Address:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        SizedBox(height: 8.0),
                        Text('${address}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        SizedBox(height: 16.0),
                        Text('Vehicle:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        SizedBox(height: 8.0),
                        Text('${vehicle}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        SizedBox(height: 16.0),
                        Text('Parking Spot:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        SizedBox(height: 8.0),
                        Text('${parkingspot}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        SizedBox(height: 16.0),
                        Text('Date:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        SizedBox(height: 8.0),
                        Text('${date}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        SizedBox(height: 16.0),
                        Text('Hours:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        SizedBox(height: 8.0),
                        Text('${hours}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        SizedBox(height: 16.0),
                        Text('Amount:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        SizedBox(height: 8.0),
                        Text('${amount}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height *
                0.2, // Adjust the height as needed
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        // SizedBox(height: 8.0),
                        Text(
                            '                                                                ${amount}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        Text('Texes & Fees:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        // SizedBox(height: 8.0),
                        Text(
                            '                                                                0.0',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        SizedBox(height: 16.0),
                        Text('Total:',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey)),
                        // SizedBox(height: 8.0),
                        Text(
                            '                                                                ${amount}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16.0)),
                        SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: RoundButton(
              title: "Continue",
              onPressed: () async {
                Map<String, dynamic> ticketData = {
                  'bookingdetails': widget.bookingData,
                  'parkingSlot': widget.selectedSpot,
                  'amount': widget.amount,
                };

                // Send ticket data to the backend
                // sendTicketDataToBackend(ticketData);
                print('------------------------');
                print(ticketData);
                sendTicketDataToBackend(ticketData);
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ParkingTicketScreen(
                            selectedSpot: widget.selectedSpot,
                            bookingData: widget.bookingData,
                            vehicleData: widget.vehicleData,
                            matchingParkArea: widget.matchingParkArea,
                            userData: widget.userData)));
              },
            ),
          ),
        ],
      ),
    );
  }
}
