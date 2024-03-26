import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Parking Ticket'),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press
            },
          ),
        ),
        body: ParkingTicketScreen(),
      ),
    );
  }
}

class ParkingTicketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Scan this on the scanner machine when you are in the parking lot',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          Image.asset('assets/img/paytm.png', width: 200, height: 200),
          SizedBox(height: 20.0),
          TicketInfoSection(),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Navigate to parking lot screen
            },
            child: Text('Navigate to Parking Lot'),
          ),
        ],
      ),
    );
  }

  Widget TicketInfoSection() {
    // Replace the following with your data
    String name = 'John Doe';
    String vehicleName = 'Car';
    String parkingArea = 'Main Parking';
    String parkingSpot = 'A08';
    String duration = '2 hours';
    String date = 'March 10, 2024';
    String hours = '12:00 PM - 2:00 PM';
    String phone = '123-456-7890';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TicketInfoRow('Name', name),
        TicketInfoRow('Vehicle Name', vehicleName),
        TicketInfoRow('Parking Area', parkingArea),
        TicketInfoRow('Parking Spot', parkingSpot),
        TicketInfoRow('Duration', duration),
        TicketInfoRow('Date', date),
        TicketInfoRow('Hours', hours),
        TicketInfoRow('Phone', phone),
      ],
    );
  }

  Widget TicketInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}
