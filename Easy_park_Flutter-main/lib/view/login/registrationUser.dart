import 'dart:convert';
import 'dart:io';

import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/login/login_User.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegistrationUser extends StatefulWidget {
  @override
  _RegistrationUserState createState() => _RegistrationUserState();
}

class _RegistrationUserState extends State<RegistrationUser> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isEmailValid = true;
  bool isPhoneValid = true;
  bool isPasswordValid = true;
  bool isPasswordVisible = false;
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  // Validation function for phone number
  String? _validatePhone(String value) {
    bool isValid = value.length == 10;
    setState(() {
      isPhoneValid = isValid;
    });
    return isValid ? null : 'Enter a valid 10-digit phone number';
  }

  // Validation function for email
  String? _validateEmail(String value) {
    bool isValid = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value.trim());
    setState(() {
      isEmailValid = isValid;
    });
    return isValid ? null : 'Enter a valid email address';
  }

  // Validation function for password
  String? _validatePassword(String value) {
    bool isValid = value.length >= 8;
    setState(() {
      isPasswordValid = isValid;
    });
    return isValid ? null : 'Password must be at least 8 characters long';
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (isEmailValid && isPhoneValid && isPasswordValid) {
      if (_selectedImage != null) {
        var request =
            http.MultipartRequest('POST', Uri.parse(registrationUser));
        request.fields['name'] = nameController.text;
        request.fields['email'] = emailController.text;
        request.fields['phone'] = phoneController.text;
        request.fields['password'] = passwordController.text;
        request.files.add(
          await http.MultipartFile.fromPath('image', _selectedImage!.path),
        );

        try {
          var response = await request.send();
          if (response.statusCode == 200) {
            Fluttertoast.showToast(
              msg: 'Registration successful',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            print('Registration successful');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginUser(),
              ),
            );
          } else {
            Fluttertoast.showToast(
              msg: 'Failed to register. Status code: ${response.statusCode}',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            print('Failed to register. Status code: ${response.statusCode}');
          }
        } catch (e) {
          print('Error during registration: $e');
        }
      } else {
        print('No image selected');
      }
    } else {
      Fluttertoast.showToast(
        msg: 'Please fill in all fields correctly',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      if (!isEmailValid) {
        Fluttertoast.showToast(
          msg: 'Enter a valid email address',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      if (!isPhoneValid) {
        Fluttertoast.showToast(
          msg: 'Enter a valid 10-digit phone number',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }

      if (!isPasswordValid) {
        Fluttertoast.showToast(
          msg: 'Password must be at least 8 characters long',
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
          'Create Your Account',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  errorText:
                      isEmailValid ? null : 'Enter a valid email address',
                ),
                onChanged: (value) {
                  _validateEmail(value);
                },
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  errorText: isPhoneValid
                      ? null
                      : 'Enter a valid 10-digit phone number',
                ),
                onChanged: (value) {
                  _validatePhone(value);
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                  errorText: isPasswordValid
                      ? null
                      : 'Password must be at least 8 characters long',
                ),
                obscureText: !isPasswordVisible,
                onChanged: (value) {
                  _validatePassword(value);
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: _selectedImage != null
                    ? CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(_selectedImage!),
                      )
                    : CircleAvatar(
                        radius: 50,
                        child: Icon(Icons.camera_alt),
                      ),
              ),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Choose Image'),
              ),
              ElevatedButton(
                onPressed: _uploadImage,
                child: Text('Register'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginUser()),
                  );
                },
                child: Text('Already have an account'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
