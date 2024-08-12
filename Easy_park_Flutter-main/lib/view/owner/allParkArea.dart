import 'dart:convert';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/owner/addparkArea.dart';
import 'package:easy_park_app/view/owner/home_view_owner.dart';
import 'package:easy_park_app/view/owner/update_parkArea.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ParkArea {
  final String address;
  final String timing;
  final String imageUrl;
  final String phone;
  final int slots;
  final String id;

  ParkArea({
    required this.address,
    required this.timing,
    required this.imageUrl,
    required this.phone,
    required this.slots,
    required this.id,
  });

  factory ParkArea.fromJson(Map<String, dynamic> json) {
    return ParkArea(
      address: json['address'] ?? '',
      timing: json['timing'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      phone: json['phone'] ?? '',
      slots: json['slots'] ?? 0,
      id: json['id'] ?? '',
    );
  }
}

class AllParkAreas extends StatefulWidget {
  @override
  _AllParkAreasState createState() => _AllParkAreasState();
}

class _AllParkAreasState extends State<AllParkAreas> {
  late List<ParkArea> parkAreas = [];
  late String ownerEmail;

  @override
  void initState() {
    super.initState();
    fetchOwnerEmail();
  }

  Future<void> fetchOwnerEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ownerEmail = prefs.getString('ownerEmail') ?? '';
    fetchParkAreas();
  }

  Future<void> fetchParkAreas() async {
    try {
      final response = await http.get(Uri.parse('$getParkAreabyemil?email=$ownerEmail'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        setState(() {
          parkAreas = responseData.map((data) => ParkArea.fromJson(data)).toList();
        });
      } else {
        print('Failed to fetch park areas. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching park areas: $error');
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
          'Park Areas',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: parkAreas.isNotEmpty
          ? ListView.builder(
              itemCount: parkAreas.length,
              itemBuilder: (context, index) {
                final parkArea = parkAreas[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UpdateParkArea(parkAreaId: parkArea.id),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      leading: Image.asset(
                          'assets/images/owners_parking/${parkArea.imageUrl}'),
                      title: Text(parkArea.address),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Timing: ${parkArea.timing}'),
                          Text('Phone: ${parkArea.phone}'),
                          Text('Slots: ${parkArea.slots}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 50),
        child: SizedBox(
          width: 350,
          child: ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeViewOwner(),
                ),
              );
            },
            child: Text('ADD A PARK AREA'),
          ),
        ),
      ),
    );
  }
}
