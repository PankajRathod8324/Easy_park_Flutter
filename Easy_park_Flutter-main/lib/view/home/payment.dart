import 'dart:convert';
import 'dart:core';

import 'package:crypto/crypto.dart';
import 'package:easy_park_app/common_widget/theme/theme_helper.dart';
import 'package:easy_park_app/common_widget/utils/image_constant.dart';
import 'package:easy_park_app/view/home/book_parking_details.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int selectedOption = -1;
  String environmentValue = "SANDBOX";
  String appId = "";
  String merchantId = "PGTESTPAYUAT";
  bool enableLogging = true;

  String checksum = "";
  String saltKey = "099eb0cd-02cf-4e2a-8aca-3e6c6aff0399";
  String saltIndex = "1";
  String apiEndPoint = "/pg/v1/pay";

  String callbackUrl =
      "https://webhook.site/dab11fac-7a9c-4bd8-bfbf-240082bfd21b";

  String body = "";

  Object? result;

  getChecksum() {
    final requestData = {
      "merchantId": merchantId,
      "merchantTransactionId": "transaction_123",
      "merchantUserId": "90223250",
      "amount": 500,
      "mobileNumber": "9999999999",
      "callbackUrl": callbackUrl,
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    String base64Body = base64Encode(utf8.encode(json.encode(requestData)));
    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';

    return base64Body;
  }

  @override
  void initState() {
    super.initState();

    paymentinit();

    body = getChecksum().toString();
  }

  @override
  Widget build(BuildContext context) {
    double boxWidth =
        MediaQuery.of(context).size.width - 32; // Adjust as needed
    double horizontalSpacing = 16;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("Payment"),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Column(
            children: [
              SizedBox(height: 20),
              _buildOption(
                  context, 0, "Google Pay", ImageConstant.googlepay, boxWidth),
              SizedBox(height: horizontalSpacing),
              _buildOption(
                  context, 1, "Phone Pay", ImageConstant.phonepay, boxWidth),
              SizedBox(height: horizontalSpacing),
              _buildOption(context, 2, "Paytm", ImageConstant.paytm, boxWidth),
              SizedBox(height: horizontalSpacing),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (selectedOption != -1) {
                    print("Selected option: $selectedOption");
                    startPgTransaction();
                  } else {
                    // Show a message or handle the case where no option is selected
                  }
                },
                child: Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index, String name,
      String imagePath, double boxWidth) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = index;
        });
      },
      child: Container(
        width: boxWidth,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        decoration: BoxDecoration(
          color: selectedOption == index
              ? Color.fromARGB(255, 216, 28, 132).withOpacity(0.2)
              : Colors.transparent,
          border: Border.all(color: theme.colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: 80,
              width: 80,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void paymentinit() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                // result = 'PhonePe SDK Initialized - $val';
              })
            })
        .catchError((error) {
      handleError(error);
      return <dynamic>{};
    });
  }

  void startPgTransaction() async {
    try {
      var response =
          PhonePePaymentSdk.startTransaction(body, callbackUrl, checksum, "");
      response
          .then((val) => {
                setState(() {
                  if (val != null) {
                    String status = val['status'].toString();
                    String error = val['error'].toString();

                    if (status == 'SUCCESS') {
                      // result = "Flow Complete - status : SUCCESS";
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookParkingPage()));
                    } else {
                      // result =
                      // "Flow Complete - status : $status and error : $error ";
                    }
                  } else {
                    // result = "Flow Incomplete";
                  }
                })
              })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      // result = {"error": error};
    });
  }
}
