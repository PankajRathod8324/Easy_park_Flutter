import 'dart:convert';
import 'dart:core';
import 'dart:ffi';

import 'package:crypto/crypto.dart';
import 'package:easy_park_app/common_widget/theme/theme_helper.dart';
import 'package:easy_park_app/common_widget/utils/image_constant.dart';
import 'package:easy_park_app/view/home/book_parking_details.dart';
import 'package:easy_park_app/view/home/parking_ticket.dart';
import 'package:easy_park_app/view/home/review_summary.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentScreen1 extends StatefulWidget {
  final Map<String, dynamic> bookingData;
  final Map<String, dynamic> vehicleData;
  final Map<String, dynamic>? matchingParkArea;
  final String selectedSpot;
  final String totalPrice;
  final Map<String, dynamic> userData;
  const PaymentScreen1(
      {super.key,
      required this.bookingData,
      required this.selectedSpot,
      required this.vehicleData,
      required this.matchingParkArea,
      required this.totalPrice,
      required this.userData});

  @override
  State<PaymentScreen1> createState() => _PaymentScreen1State();
}

class _PaymentScreen1State extends State<PaymentScreen1> {
  late Razorpay _razorpay;
  TextEditingController amtController = TextEditingController();
  late String amount;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalleet);
    double totalPrice = widget.bookingData['totalPrice'];
    String temp = totalPrice
        .toStringAsFixed(0); // Convert to string and remove decimal part
    amount = temp;
    amtController.text = amount;
  }

  void openCheckout(int amount) async {
    var options = {
      'key': 'rzp_test_qZ0R0cFMylkhJc',
      'amount': amount * 100,
      'name': 'Parking App',
      'prefill': {'contact': '1234567890', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Successful " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ReviewSummaryView(
                  selectedSpot: widget.selectedSpot,
                  bookingData: widget.bookingData,
                  vehicleData: widget.vehicleData,
                  matchingParkArea: widget.matchingParkArea,
                  amount: '10',
                  userData: widget.userData,
                )));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "Payment Fail " + response.message!,
        toastLength: Toast.LENGTH_SHORT);
  }

  void handleExternalWalleet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT);
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  double totalPrice = 0.0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 10),
          Image.asset(
            'assets/img/img_image_2.png',
            width: 200,
            height: 200,
          ),
          SizedBox(height: 30),
          Text(
            "Welcome to Razorpay Payment Gateway Integration",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              cursorColor: Colors.white,
              autofocus: false,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  labelText: 'Enter Amount to be paid',
                  labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  )),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Colors.white,
                    width: 1.0,
                  )),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15)),
              controller: amtController,
              enabled: false,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter amount';
                }
                return null;
              },
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              // Parse amount from controller and pass it to openCheckout
              int amount = int.tryParse(amtController.text) ?? 0;
              openCheckout(amount);
            },
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Make Payment"),
            ),
            style: ElevatedButton.styleFrom(primary: Colors.green),
          )
        ]),
      ),
    );
  }
}
