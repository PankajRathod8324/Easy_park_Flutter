import 'dart:convert';
import 'dart:io';
import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/line_text_field.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AddParkArea extends StatefulWidget {
  final LatLng position;

  const AddParkArea({Key? key, required this.position}) : super(key: key);

  @override
  State<AddParkArea> createState() => _AddParkAreaState();
}

class _AddParkAreaState extends State<AddParkArea> {
  TextEditingController txtPincode = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtTiming = TextEditingController();

  List<String> images = [];
  String selectedSeat = '4 Wheeler'; // Default seat type

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 25,
            height: 25,
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Parking Area",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 25,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              LineTextField(
                title: "Pincode",
                hintText: "Enter Pincode",
                controller: txtPincode,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Phone",
                hintText: "Enter Phone",
                controller: txtPhone,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Address",
                hintText: "Enter Address",
                controller: txtAddress,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
                title: "Timing",
                hintText: "Enter Timing",
                controller: txtTiming,
              ),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () {
                  pickImages();
                },
                child: Text('Pick Images (Max 3)'),
              ),
              if (images.isNotEmpty)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: images
                          .map(
                            (image) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(
                                File(image),
                                width: 100,
                                height: 100,
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    if (images.length < 3)
                      ElevatedButton(
                        onPressed: () {
                          pickImages();
                        },
                        child: Text('Add More Images'),
                      ),
                  ],
                ),
              const SizedBox(
                height: 8,
              ),
              RoundButton(
                onPressed: () {
                  sendParkAreaDetailsToBackend();
                },
                title: "ADD PARKING AREA",
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeView()),
                  );
                },
                child: Text(
                  "SKIP",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void pickImages() async {
    final picker = ImagePicker();
    List<XFile>? pickedImages = await picker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      if (images.length + pickedImages.length > 3) {
        Fluttertoast.showToast(
          msg: 'You can only select up to 3 images',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      setState(() {
        images.addAll(pickedImages.map((image) => image.path));
      });
    }
  }

  Future<void> sendParkAreaDetailsToBackend() async {
    final String pincode = txtPincode.text;
    final String phone = txtPhone.text;
    final List<String> imagesList = images;
    final String address = txtAddress.text;
    final String timing = txtTiming.text;

    if (pincode.isEmpty ||
        phone.isEmpty ||
        imagesList.isEmpty ||
        address.isEmpty ||
        timing.isEmpty) {
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

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ownerEmail = prefs.getString('ownerEmail');
    final double latitude = widget.position.latitude;
    final double longitude = widget.position.longitude;
    var request = http.MultipartRequest('POST', Uri.parse(addParkArea));
    request.fields['ownerEmail'] = ownerEmail!;
    request.fields['pincode'] = pincode;
    request.fields['phone'] = phone;
    request.fields['address'] = address;
    request.fields['timing'] = timing;
    request.fields['latitude'] = latitude.toString();
    request.fields['longitude'] = longitude.toString();
    for (int i = 0; i < imagesList.length; i++) {
      var file = File(imagesList[i]);
      request.files.add(
        await http.MultipartFile.fromPath('images', file.path),
      );
    }

    try {
      var response = await request.send();

      print(response.statusCode);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Add Successfully');
        Fluttertoast.showToast(
          msg: 'Parking area added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      } else {
        print('Add failed. Status code: ${response.statusCode}');
        Fluttertoast.showToast(
          msg: 'Add failed. Please check your input and try again.',
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
    }
  }
}
