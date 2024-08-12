import 'dart:convert';
import 'dart:io';

import 'package:easy_park_app/view/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UpdateParkArea extends StatefulWidget {
  final String parkAreaId;

  const UpdateParkArea({Key? key, required this.parkAreaId}) : super(key: key);

  @override
  State<UpdateParkArea> createState() => _UpdateParkAreaState();
}

class _UpdateParkAreaState extends State<UpdateParkArea> {
  TextEditingController txtPincode = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtAddress = TextEditingController();
  TextEditingController txtTiming = TextEditingController();
  TextEditingController txtSlots = TextEditingController();
  TextEditingController txtPricePerHr = TextEditingController();

  List<String> images = [];
  List<String> newimages = [];

  File? image; // New variable for image file
  String imageUrl = ''; // New variable for image URL

  @override
  void initState() {
    super.initState();
    fetchParkAreaDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Update Park Area',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: txtPincode,
                decoration: InputDecoration(labelText: "Pincode"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: txtPhone,
                decoration: InputDecoration(labelText: "Phone"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: txtAddress,
                decoration: InputDecoration(labelText: "Address"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: txtSlots,
                decoration: InputDecoration(labelText: "Slots"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: txtTiming,
                decoration: InputDecoration(labelText: "Timing"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: txtPricePerHr,
                decoration: InputDecoration(labelText: "Price Per Hour"),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {
                  pickImages();
                },
                child: Text('Pick Images (Max 3)'),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: images
                    .asMap()
                    .entries
                    .map((entry) => Stack(
                          children: [
                            Image.asset(
                              'assets/images/owners_parking/${entry.value}',
                              width: 100,
                              height: 100,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () {
                                  removeImage(entry.key);
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
                        ))
                    .toList(),
              ),
              if (newimages.length > 0) Text("New Images"),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: newimages
                    .asMap()
                    .entries
                    .map(
                      (entry) => Stack(
                        children: [
                          Image.file(
                            File(entry.value),
                            width: 100,
                            height: 100,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                removeImage(entry
                                    .key); // Use entry.key to remove from newimages
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
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  updateParkAreaDetails();
                },
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void fetchParkAreaDetails() async {
    try {
      final response =
          await http.get(Uri.parse('$getParkArea?id=${widget.parkAreaId}'));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final data = responseData['data'];

        setState(() {
          txtPincode.text = data['pincode'];
          txtPhone.text = data['phone'];
          txtAddress.text = data['address'];
          txtTiming.text = data['timing'];
          txtSlots.text = data['slots'].toString();
          txtPricePerHr.text = data['price_per_hr']
              .toString(); // Update the text field for price_per_hr
          images = List<String>.from(data['images']);
        });
      } else {
        throw Exception('Failed to fetch park area details');
      }
    } catch (e) {
      print('Error fetching park area details: $e');
    }
  }

  Future<void> updateParkAreaDetails() async {
    final String pincode = txtPincode.text;
    final String phone = txtPhone.text;
    final List<String> imagesList = images;
    final String address = txtAddress.text;
    final String timing = txtTiming.text;
    final String slots = txtSlots.text;
    final String pricePerHr =
        txtPricePerHr.text; // Retrieve price_per_hr from the text field

    if (pincode.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        timing.isEmpty ||
        slots.isEmpty ||
        pricePerHr.isEmpty) {
      // Check if pricePerHr is empty
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

    var request = http.MultipartRequest(
        'PUT', Uri.parse('$updateParkArea?id=${widget.parkAreaId}'));
    request.fields['parkAreaId'] = widget.parkAreaId;
    request.fields['pincode'] = pincode;
    request.fields['phone'] = phone;
    request.fields['address'] = address;
    request.fields['timing'] = timing;
    request.fields['slots'] = slots;
    request.fields['price_per_hr'] =
        pricePerHr; // Add price_per_hr to request fields
    request.fields['images'] = jsonEncode(imagesList);
    // Add image file to request
    for (int i = 0; i < newimages.length; i++) {
      var file = File(newimages[i]);
      request.files.add(
        await http.MultipartFile.fromPath('images', file.path),
      );
    }

    try {
      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        Fluttertoast.showToast(
          msg: 'Parking area updated successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(
          msg: 'Update failed. Please check your input and try again.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Error during update. Please try again later.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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

      // Create a new list to hold the updated images

      // Add existing images to the new list

      // Add newly picked images to the new list
      newimages.addAll(pickedImages.map((image) => image.path));

      setState(() {
        newimages = newimages; // Update the images list with the new list
      });
    }
  }

  void pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path); // Comment: Set selected image
      });
    }
  }

  void removeImage(int index) {
    setState(() {
      // Remove the image path from the list
      String imagePath = images.removeAt(index);

      // Delete the corresponding file from the device storage
      deleteFile(imagePath);
    });
  }

  Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print('File deleted successfully: $filePath');
      } else {
        print('File does not exist: $filePath');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }
}
