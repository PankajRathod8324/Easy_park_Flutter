import 'package:flutter/material.dart';
import 'package:easy_park_app/view/owner/owner.dart'; // Import Owner class from owner.dart

class OwnerDetailsPage extends StatefulWidget {
  final Owner owner;

  const OwnerDetailsPage({Key? key, required this.owner}) : super(key: key);

  @override
  _OwnerDetailsPageState createState() => _OwnerDetailsPageState();
}

class _OwnerDetailsPageState extends State<OwnerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    // Access the length of the parkAreas list
    int parkAreasLength = widget.owner.parkingAreas.length;
    print(widget.owner.parkingAreas);
    print('-------------');
    print(parkAreasLength);
    return Scaffold(
      backgroundColor: Colors.grey[200],
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
          'Owner Details',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.width * 0.6,
                  alignment: Alignment.topCenter,
                  color: Colors.grey[200], // Change to your desired color
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.width * 0.35,
                    color: Colors.grey[200], // Change to your desired color
                  ),
                ),
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 60),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(color: Colors.black12, blurRadius: 2)
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                Text(
                                  widget.owner.name,
                                  style: TextStyle(
                                    color: Colors
                                        .black, // Change to your desired color
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  height: 0.5,
                                  width: double.infinity,
                                  color: Colors
                                      .grey, // Change to your desired color
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildTitleSubtitleCell(
                                          widget.owner.phone,
                                          "Phone"), // Updated to use phone property
                                    ),
                                    Container(
                                      height: 60,
                                      width: 0.5,
                                      color: Colors
                                          .grey, // Change to your desired color
                                    ),
                                    Expanded(
                                      child: _buildTitleSubtitleCell(
                                          widget.owner.parkingAreas.length
                                              .toString(),
                                          "Total Parking Areas"), // Updated to use parkingAreas property
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.asset(
                                widget.owner.imageUrl.isNotEmpty
                                    ? 'assets/images/${widget.owner.imageUrl}'
                                    : "assets/img/u1.png",
                                width: 100,
                                height: 100,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Handle onTap for ratings
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                color: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Your rating icon and text here
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 25,
              width: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "PERSONAL INFO",
                    style: TextStyle(
                        color: Colors.black, // Change to your desired color
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 25,
                    width: 900,
                  ),
                  Container(
                    padding: EdgeInsets.all(25),
                    width: 900,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPersonalInfoItem("Name", widget.owner.name),
                        _buildPersonalInfoItem("Email", widget.owner.email),
                        _buildPersonalInfoItem("Phone", widget.owner.phone),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
                height: 20), // Add space between personal info and back button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Navigate back to previous screen
                },
                child: Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleSubtitleCell(String title, String subtitle) {
    return Container(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black, // Change to your desired color
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey, // Change to your desired color
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black, // Change to your desired color
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey, // Change to your desired color
            fontSize: 14,
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
