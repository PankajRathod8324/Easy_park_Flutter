import 'dart:convert';
import 'dart:core';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
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
      "amount": 1000,
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
    // TODO: implement initState
    super.initState();

    paymentinit();

    body = getChecksum().toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("PhonePay Payment Gateway"),
          ),
          body: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  startPgTransaction();
                },
                child: Text("Start Transaction"),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Result \n $result")
            ],
          )),
    );
  }

  void paymentinit() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogging)
        .then((val) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $val';
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
                      result = "Flow Complete - status : SUCCESS";
                    } else {
                      result =
                          "Flow Complete - status : $status and error : $error ";
                    }
                  } else {
                    result = "Flow Incomplete";
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
      result = {"error": error};
    });
  }
}

// Test Card Details
// Debit Card
// anchor image
// “card_number”: “4242424242424242”,
// “card_type”: “DEBIT_CARD”,
// “card_issuer”: “VISA”,
// “expiry_month”: 12,
// “expiry_year”: 2023,
// “cvv”: “936”

// Credit Card
// anchor image
// “card_number”: “4208585190116667”,
// “card_type”: “CREDIT_CARD”,
// “card_issuer”: “VISA”,
// “expiry_month”: 06,
// “expiry_year”: 2027,
// “cvv”: “508”

// Note: The OTP to be used on the Bank Page: 123456

// How to verify Net Banking Flow
// anchor image
// Always use “bankId”: “SBIN” for testing purposes in the request payload of PAY API.

// Username: test
// Password: test
// and click “Submit” on the next screen.

// Note: For testing transactions, the lower amount limit is defined as Rs.1/- and the upper amount limit is defined as Rs.1000/-. Please make sure your transaction requests are within these limits.