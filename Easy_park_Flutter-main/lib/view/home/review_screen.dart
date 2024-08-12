import 'dart:convert';
import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/line_text_field.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class ReviewScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final Map<String, dynamic> bookingData;
  final Map<String, dynamic>? matchingParkArea;

  const ReviewScreen(
      {Key? key,
      required this.userData,
      required this.bookingData,
      required Map<String, dynamic> vehicleData,
      required this.matchingParkArea})
      : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  TextEditingController txtRating = TextEditingController();
  TextEditingController txtReview = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print('Usernamae');
    print(widget.userData['name']);
    print(DateTime.now().toString());
    print(widget.bookingData);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: TColor.primaryText),
        ),
        centerTitle: true,
        title: Text(
          "Rating & Review",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            LineTextField(
              title: "Rating",
              hintText: "Enter Rating",
              controller: txtRating,
            ),
            const SizedBox(height: 8),
            LineTextField(
              title: "Review",
              hintText: "Enter Review",
              controller: txtReview,
            ),
            const SizedBox(height: 8),
            RoundButton(
              onPressed: () {
                sendReviewDetailsToBackend();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              },
              title: "ADD Review",
            ),
            RoundButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => HomeView(),
                ));
              },
              title: "Skip",
            ),
          ],
        ),
      ),
    );
  }

  Future<void> sendReviewDetailsToBackend() async {
    final String rating = txtRating.text;
    final String review = txtReview.text;

    if (rating.isEmpty || review.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all the required fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(addreview), // Replace with your backend URL
        body: jsonEncode({
          'username': widget.userData['name'],
          'date': widget.bookingData['bookingDate'],
          'rating': rating,
          'review': review,
          'ParkAreaId': widget.matchingParkArea?['id'],
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print('---------------------');
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Review added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context); // Go back after successful addition
      } else {
        Fluttertoast.showToast(
          msg: 'Failed to add review. Please try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print('Error during add: $e');
      Fluttertoast.showToast(
        msg: 'An error occurred. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
