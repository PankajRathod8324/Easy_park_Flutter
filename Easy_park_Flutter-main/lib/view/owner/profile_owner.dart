import 'dart:convert';

import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/icon_title_cell.dart';
import 'package:easy_park_app/common_widget/menu_row.dart';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/Profile/my_profile_view.dart';
// import 'package:easy_park_app/view/login/login_owner.dart'; // Update import
import 'package:easy_park_app/view/Profile/payment_view.dart';
import 'package:easy_park_app/view/login/choose_owner_user.dart';
// import 'package:easy_park_app/view/menu/settings_view.dart';
// import 'package:easy_park_app/view/menu/summary_view.dart';
// import 'package:easy_park_app/view/menu/wallet_view.dart';
import 'package:easy_park_app/view/owner/allParkArea.dart';
import 'package:easy_park_app/view/owner/booking_details_view.dart';
import 'package:easy_park_app/view/owner/loginOwner.dart';
import 'package:easy_park_app/view/owner/owner_details_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:easy_park_app/view/owner/owner.dart';

// Owner class representing owner details

class ProfileOwner extends StatefulWidget {
  const ProfileOwner({Key? key});

  @override
  State<ProfileOwner> createState() => _ProfileOwnerState();
}

class _ProfileOwnerState extends State<ProfileOwner> {
  late String ownerEmail;
  late Owner ownerDetails = Owner(
    name: 'Guest',
    phone: 'N/A',
    imageUrl: '',
    parkingAreas: [],
    email: '',
  );

  @override
  void initState() {
    super.initState();
    // Fetch owner details from local storage
    getOwnerDetails();
  }

  Future<void> getOwnerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ownerEmail = prefs.getString('ownerEmail') ?? '';
    print("Owner email: " + ownerEmail);
    // Fetch owner details from the backend using the stored email
    try {
      final response = await http.get(
        Uri.parse(
            '$getOwnerdetails?email=$ownerEmail'), // Replace with your actual API endpoint
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> ownerData = json.decode(response.body);
        ownerDetails = Owner(
          name: ownerData['name'] ?? 'Guest',
          phone: ownerData['phone'] ?? 'N/A',
          imageUrl: ownerData['imageUrl'] ?? '',
          parkingAreas: List<String>.from(ownerData['parkAreas'] ?? []),
          email: ownerEmail,
        );
        print(ownerDetails.parkingAreas);
        setState(() {});
      } else {
        print(
            'Failed to fetch owner details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during owner details fetch: $e');
    }
  }

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('ownerEmail');
    // Navigate to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ChooseOwnerUser(), // Update to the owner login page
      ),
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
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [
                    //     IconTitleCell(
                    //       title: "Payments",
                    //       icon: "assets/img/earnings.png",
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => PaymentView(),
                    //           ),
                    //         );
                    //       },
                    //     ),
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
                                  ownerDetails.imageUrl.isNotEmpty
                                      ? 'assets/images/${ownerDetails.imageUrl}'
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
                            ownerDetails.name,
                            style: TextStyle(
                              color: TColor.primaryTextW,
                              fontSize: 16,
                            ),
                          )
                        ],
                      ),
                    ),
                    //     IconTitleCell(
                    //       title: "Wallet",
                    //       icon: "assets/img/wallet.png",
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => WalletView(),
                    //           ),
                    //         );
                    //       },
                    //     ),
                    //   ],
                    // )
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
                    title: "Park Areas",
                    icon: "assets/img/home.png",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllParkAreas(),
                        ),
                      );
                    },
                  ),
                  MenuRow(
                    title: "My Profile",
                    icon: "assets/img/sm_profile.png",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OwnerDetailsPage(
                            owner: ownerDetails,
                          ),
                        ),
                      );
                    },
                  ),
                  MenuRow(
                    title: "Booking In Your ParkArea",
                    icon: "assets/img/notification.png",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OwnerBookingDetailsPage(), // Update to the owner login page
                        ),
                      );
                    },
                  ),
                  MenuRow(
                    title: "Logout",
                    icon: "assets/img/logout.png",
                    onPressed: logout,
                  ),
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
