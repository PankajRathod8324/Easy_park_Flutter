import 'dart:convert';

import 'package:easy_park_app/view/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileView extends StatefulWidget {
  final String userEmail;

  const ProfileView({Key? key, required this.userEmail}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late String userEmail;
  String userName = ""; // Placeholder for name
  String userLocation = ""; // Placeholder for location
  String userPhone = ""; // Placeholder for phone number
  String imageUrl = ""; // Placeholder for
  String imageName = ""; // Placeholder for image name
  String address = "";

  @override
  void initState() {
    super.initState();
    userEmail = widget.userEmail;
    _getOwnerDetails();
  }

  Future<void> _getOwnerDetails() async {
    try {
      final response = await http.get(
        Uri.parse(getOwnerdetails + '?email=$userEmail'),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> ownerDetails = json.decode(response.body);

        setState(() {
          userName = ownerDetails['name'];
          userLocation =
              'Latitude: ${ownerDetails['location']['latitude']}, Longitude: ${ownerDetails['location']['longitude']}';
          userPhone = ownerDetails['phone'];
          imageUrl = ownerDetails['imageUrl'];
          address = ownerDetails['address'];

          // Extracting image name from the URL
          imageName = imageUrl.split('\\').last;
        });
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered profile image with rounded edges
            ClipOval(
              child: Image.asset(
                'assets/images/$imageName',
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            // User details with styled boxes
            _buildInfoBox('Name', userName),
            SizedBox(height: 8.0),
            _buildInfoBox('Location', userLocation),
            SizedBox(height: 8.0),
            _buildInfoBox('Phone', userPhone),
            SizedBox(height: 8.0),
            _buildInfoBox('Image Name', imageName),
            SizedBox(height: 8.0),
            _buildInfoBox('Address', address),
          ],
        ),
      ),
    );
  }

  // Helper method to create styled info boxes
  Widget _buildInfoBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
