import 'dart:convert';

import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/icon_title_cell.dart';
import 'package:easy_park_app/common_widget/menu_row.dart';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/login/login_User.dart';
import 'package:easy_park_app/view/menu/payment_view.dart';
import 'package:easy_park_app/view/menu/settings_view.dart';
import 'package:easy_park_app/view/menu/summary_view.dart';
import 'package:easy_park_app/view/menu/wallet_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView> {
  late String userEmail;
  late String userName;  // Add this variable to store the user's name

  @override
  void initState() {
    super.initState();
    // Fetch user details from local storage
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userEmail = prefs.getString('userEmail') ?? '';
    
    // Fetch user details from the backend using the stored email
    try {
      final response = await http.get(
        Uri.parse('$getUser?userEmail=$userEmail'),  // Replace with your actual API endpoint
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = json.decode(response.body);
        userName = userData['name'] ?? '';
        setState(() {});
      } else {
        print('Failed to fetch user details. Status code: ${response.statusCode}');
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconTitleCell(
                            title: "Payments",
                            icon: "assets/img/earnings.png",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PaymentView()),
                              );
                            }),
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
                                      "assets/img/u1.png",
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                userName,  // Display the user's name
                                style: TextStyle(
                                  color: TColor.primaryTextW,
                                  fontSize: 16,
                                ),
                              )
                            ],
                          ),
                        ),
                        IconTitleCell(
                            title: "Wallet",
                            icon: "assets/img/wallet.png",
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => WalletView()));
                            }),
                      ],
                    )
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
                      onPressed: () {}),
                  MenuRow(
                      title: "Summary",
                      icon: "assets/img/summary.png",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SummaryView()));
                      }),
                  MenuRow(
                      title: "Notifications",
                      icon: "assets/img/notification.png",
                      onPressed: () {}),
                  MenuRow(
                      title: "Settings",
                      icon: "assets/img/setting.png",
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsView()));
                      }),
                  MenuRow(
                      title: "Logout",
                      icon: "assets/img/logout.png",
                      onPressed: logout),  // Call the logout method
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
