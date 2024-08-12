import 'dart:convert';
import 'dart:io';
import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/line_text_field.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/config/config.dart';
<<<<<<< HEAD
import 'package:easy_park_app/view/login/choose_owner_user.dart';
// import 'package:easy_park_app/view/home/home_view.dart';
import 'package:easy_park_app/view/owner/home_view_owner.dart';
import 'package:easy_park_app/view/owner/profile_owner.dart';
=======
import 'package:easy_park_app/view/home/home_view.dart';
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
  TextEditingController txtname = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtTiming = TextEditingController();
  TextEditingController txtslots = TextEditingController();
  TextEditingController txtpriceperhour = TextEditingController();
=======
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtTiming = TextEditingController();

>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
                title: "Name",
                hintText: "Enter Name",
                controller: txtname,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
                title: "Slots",
                hintText: "Number of slots available",
                controller: txtslots,
              ),
              const SizedBox(
                height: 8,
              ),
              LineTextField(
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
                title: "Timing",
                hintText: "Enter Timing",
                controller: txtTiming,
              ),
              const SizedBox(
                height: 25,
              ),
<<<<<<< HEAD
              LineTextField(
                title: "Price Per Hour",
                hintText: "Enter Price Per Hour",
                controller: txtpriceperhour,
              ),
              const SizedBox(
                height: 25,
              ),
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
              ElevatedButton(
                onPressed: () {
                  pickImages();
                },
                child: Text('Pick Images (Max 3)'),
              ),
              if (images.isNotEmpty)
<<<<<<< HEAD
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: images
                        .map(
                          (image) => Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.file(
                                  File(image),
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    removeImage(image);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 12,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              if (images.length < 3)
                ElevatedButton(
                  onPressed: () {
                    pickImages();
                  },
                  child: Text('Add More Images'),
=======
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
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
                    MaterialPageRoute(builder: (context) => HomeViewOwner()),
=======
                    MaterialPageRoute(builder: (context) => HomeView()),
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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

<<<<<<< HEAD
  void removeImage(String image) {
    setState(() {
      images.remove(image);
    });
  }

=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
  Future<void> sendParkAreaDetailsToBackend() async {
    final String pincode = txtPincode.text;
    final String phone = txtPhone.text;
    final List<String> imagesList = images;
    final String address = txtAddress.text;
    final String timing = txtTiming.text;
<<<<<<< HEAD
    final String slots = txtslots.text; // Extract slots from the text field
    final String name = txtname.text;
    final String pricePerHour = txtpriceperhour.text;
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766

    if (pincode.isEmpty ||
        phone.isEmpty ||
        imagesList.isEmpty ||
        address.isEmpty ||
<<<<<<< HEAD
        timing.isEmpty ||
        slots.isEmpty ||
        name.isEmpty ||
        pricePerHour.isEmpty) {
      // Ensure slots is not empty
=======
        timing.isEmpty) {
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
    request.fields['name'] = name;
    request.fields['price_per_hr'] = pricePerHour;
    request.fields['phone'] = phone;
    request.fields['address'] = address;
    request.fields['timing'] = timing;
    request.fields['slots'] = slots; // Add slots to the request fields
=======
    request.fields['phone'] = phone;
    request.fields['address'] = address;
    request.fields['timing'] = timing;
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
          MaterialPageRoute(builder: (context) => ProfileOwner()),
=======
          MaterialPageRoute(builder: (context) => HomeView()),
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
