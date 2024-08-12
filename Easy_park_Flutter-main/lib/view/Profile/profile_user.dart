import 'dart:convert';

import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/icon_title_cell.dart';
import 'package:easy_park_app/common_widget/menu_row.dart';
import 'package:easy_park_app/view/Profile/user.dart';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/home/home_view.dart';
import 'package:easy_park_app/view/login/bookigDetails_user.dart';
import 'package:easy_park_app/view/login/choose_owner_user.dart';
import 'package:easy_park_app/view/login/login_User.dart';
import 'package:easy_park_app/view/Profile/my_profile_view.dart';
import 'package:easy_park_app/view/Profile/my_vehicle_view.dart';
import 'package:easy_park_app/view/Profile/payment_view.dart';
// import 'package:easy_park_app/view/menu/settings_view.dart';
// import 'package:easy_park_app/view/menu/summary_view.dart';
// import 'package:easy_park_app/view/menu/wallet_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileUserView extends StatefulWidget {
  const ProfileUserView({super.key});

  @override
  State<ProfileUserView> createState() => _ProfileUserViewState();
}

class _ProfileUserViewState extends State<ProfileUserView> {
  late String userEmail;
  late String userName = ''; // Add this variable to store the user's name
  late User userDetails = User(
    name: 'Guest',
    phone: 'N/A',
    imageUrl: '',
    email: '',
  );
  @override
  void initState() {
    super.initState();
    // Fetch user details from local storage
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail') ?? '';
    print("User  email: " + userEmail);

    // Fetch user details from the backend using the stored email
    try {
      final response = await http.get(
        Uri.parse(
            '$getUser?email=$userEmail'), // Replace with your actual API endpoint
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        print(response.body);
        userDetails = User(
          name: userData['name'] ?? 'Guest',
          phone: userData['phone'] ?? 'N/A',
          imageUrl: userData['profile'] ?? '',
          email: userEmail,
        );
        setState(() {});
      } else {
        print(
            'Failed to fetch user details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during user details fetch: $e');
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userEmail');
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginUser()),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('------------');
    print(userDetails.imageUrl);
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: TColor.primaryText),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Image.asset(
                            "assets/img/close.png",
                            width: 20,
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              "assets/img/question_mark.png",
                              width: 20,
                              height: 20,
                              color: Colors.white,
                            ),
                            Text(
                              "Help",
                              style: TextStyle(
                                color: TColor.primaryTextW,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset(
                                  userDetails.imageUrl.isNotEmpty
                                      ? 'assets/images/user/${userDetails.imageUrl}'
                                      : "assets/img/u1.png",
                                  width: 150,
                                  height: 150,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            userDetails.name, // Display the user's name
                            style: TextStyle(
                              color: TColor.primaryTextW,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MenuRow(
                      title: "Home",
                      icon: "assets/img/home.png",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeView()));
                      }),
                  MenuRow(
                      title: "My Profile",
                      icon: "assets/img/summary.png",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyProfileView()));
                      }),

                  MenuRow(
                      title: "My Vehicles",
                      icon: "assets/img/setting.png",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyVehicleView()));
                      }),
                  MenuRow(
                      title: "Booking Details",
                      icon: "assets/img/notification.png",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    UserBookingDetailsPage()));
                      }),
                  MenuRow(
                      title: "Logout",
                      icon: "assets/img/logout.png",
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChooseOwnerUser()));
                      }), // Call the logout method
                  const SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
