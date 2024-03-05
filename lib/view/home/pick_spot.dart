import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PickSpotScreen(),
    );
  }
}

class PickSpotScreen extends StatefulWidget {
  @override
  _PickSpotScreenState createState() => _PickSpotScreenState();
}

class _PickSpotScreenState extends State<PickSpotScreen> {
  String selectedFloor = "1st Floor";
  List<String> parkingSpots = ["A01", "A02", "A03", "A04", "A05", "A06", "A07", "A08", "A09", "A10", "A11", "A12"];
  List<bool> occupiedSpots = List.generate(12, (index) => false);
  String timeStamp = "9:10 AM";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pick Parking Spot"),
      ),
      body: Column(
        children: [
          _buildTabs(),
          _buildParkingSpots(),
          _buildTimestamp(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildTab("1st Floor"),
        _buildTab("2nd Floor"),
        _buildTab("3rd Floor"),
      ],
    );
  }

  Widget _buildTab(String floor) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFloor = floor;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedFloor == floor ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          floor,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildParkingSpots() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Parking Spots on $selectedFloor:"),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: parkingSpots.sublist(0, 6).map((spot) => _buildParkingSpot(spot)).toList(),
                ),
                SizedBox(width: 20),
                Column(
                  children: parkingSpots.sublist(6, 12).map((spot) => _buildParkingSpot(spot)).toList(),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text("Entry", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("2 WAY TRAFFIC", style: TextStyle(color: Colors.blue)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle button click
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParkingSpot(String spot) {
    int spotIndex = parkingSpots.indexOf(spot);
    bool isOccupied = occupiedSpots[spotIndex];

    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle spot occupation status
          occupiedSpots[spotIndex] = !occupiedSpots[spotIndex];
        });
      },
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isOccupied ? Colors.red : Colors.green,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                spot,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 8),
          // Show car icon only if the spot is occupied
          if (isOccupied) Icon(Icons.directions_car, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildTimestamp() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Text("Time Stamp: $timeStamp"),
    );
  }
}
