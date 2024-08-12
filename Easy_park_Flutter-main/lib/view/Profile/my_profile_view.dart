import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/icon_title_row.dart';
import 'package:easy_park_app/common_widget/title_subtitle_cell.dart';
import 'package:easy_park_app/view/Profile/user.dart';
import 'package:easy_park_app/view/config/config.dart';
// import 'package:easy_park_app/view/menu/edit_profile_view.dart';
// import 'package:easy_park_app/view/menu/ratings_view.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfileView extends StatefulWidget {
  // final Map<String, dynamic> userDetails;
  const MyProfileView({super.key});

  @override
  State<MyProfileView> createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  String userName = '';
  String userEmail = '';
  String userPhone = '';
  String userTrips = '';
  String userExperience = '';
  String userRating = '';

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail') ?? '';

    try {
      final response = await http.get(
        Uri.parse(
            '$getUser?email=$userEmail'), // Replace with your actual API endpoint
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        print(userData);
        userName = userData['name'] ?? '';
        userPhone = userData['phone'] ?? '';
        // userTrips = userData['totalTrips'] ?? '';
        // userExperience = userData['experience'] ?? '';
        // userRating = userData['rating'] ?? '';
        setState(() {});
      } else {
        print(
            'Failed to fetch user details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during user details fetch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.lightWhite,
      appBar: AppBar(
        backgroundColor: const Color(0xff282F39),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 25,
            height: 25,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => EditProfileView()));
            },
            icon: const Icon(
              Icons.edit,
              size: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.maxFinite,
                  height: MediaQuery.of(context).size.width * 0.6,
                  alignment: Alignment.topCenter,
                  child: Container(
                    width: double.maxFinite,
                    height: MediaQuery.of(context).size.width * 0.35,
                    color: const Color(0xff282F39),
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
                                  userName,
                                  style: TextStyle(
                                    color: TColor.primaryText,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  height: 0.5,
                                  width: double.maxFinite,
                                  color: TColor.lightGray,
                                ),
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
                                "assets/img/u1.png",
                                width: 100,
                                height: 100,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => RatingsView()));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                color: Colors.white,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      "assets/img/rate_profile.png",
                                      width: 15,
                                      height: 15,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      userRating,
                                      style: TextStyle(
                                        color: TColor.primaryText,
                                        fontSize: 13,
                                      ),
                                    ),
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
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Text(
                "PERSONAL INFO",
                style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 15,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Column(
                children: [
                  IconTitleRow(
                      icon: "assets/img/phone.png",
                      title: userPhone,
                      onPressed: () {}),
                  IconTitleRow(
                      icon: "assets/img/email.png",
                      title: userEmail,
                      onPressed: () {}),
                  // Other IconTitleRow widgets...
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
