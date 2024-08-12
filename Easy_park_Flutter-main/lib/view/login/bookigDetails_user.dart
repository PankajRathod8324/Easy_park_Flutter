import 'dart:convert';
import 'package:easy_park_app/view/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserBookingDetailsPage extends StatefulWidget {
  UserBookingDetailsPage();

  @override
  _UserBookingDetailsPageState createState() =>
      _UserBookingDetailsPageState();
}

class _UserBookingDetailsPageState extends State<UserBookingDetailsPage> {
  late Future<Map<String, dynamic>> _userBookingDetails;
  late String userEmail = '';

  @override
  void initState() {
    super.initState();
    _userBookingDetails = fetchUserBookingDetails();
  }

  Future<Map<String, dynamic>> fetchUserBookingDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail') ?? '';
    final response = await http.get(Uri.parse('$getUserBookingDetails?email=$userEmail'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user booking details');
    }
  }

  void cancelBooking(String bookingId) async {
    try {
      final response = await http.get(
        Uri.parse('$cancleBooking?id=$bookingId'), // Replace with your cancel booking endpoint
      );
      if (response.statusCode == 200) {
        // Booking cancelled successfully, reload booking details
        setState(() {
          _userBookingDetails = fetchUserBookingDetails();
        });
      } else {
        throw Exception('Failed to cancel booking');
      }
    } catch (error) {
      print('Error cancelling booking: $error');
      // Handle error
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
          'Booking Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userBookingDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return buildUserDetails(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget buildUserDetails(Map<String, dynamic> data) {
    return ListView.builder(
      itemCount: data['bookingDetails'].length,
      itemBuilder: (context, index) {
        var booking = data['bookingDetails'][index];
        var parkAreaId = booking['parkArea'];
        var parkAreaDetails = data['parkAreaDetails'].firstWhere(
          (area) => area['_id'] == parkAreaId,
          orElse: () => {'name': 'Unknown'}
        );

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
              if (booking['status'] == 'Booked')
                ElevatedButton(
                  onPressed: () {
                    // Call the function to cancel booking
                    cancelBooking(booking['_id']);
                  },
                  child: Text('Cancel'),
                ),
            ],
          ),
        );
      },
    );
  }
}
