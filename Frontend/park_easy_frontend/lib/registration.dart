// // import 'dart:convert';
// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:velocity_x/velocity_x.dart';
// // import 'package:http/http.dart' as http;
// // import 'config.dart';
// // import 'loginPage.dart';
// // import 'package:image_picker/image_picker.dart';

// // class Registration extends StatefulWidget {
// //   @override
// //   _RegistrationState createState() => _RegistrationState();
// // }

// // class _RegistrationState extends State<Registration> {
// //   TextEditingController nameController = TextEditingController();
// //   TextEditingController emailController = TextEditingController();
// //   TextEditingController passwordController = TextEditingController();
// //   TextEditingController confirmPasswordController = TextEditingController();
// //   TextEditingController phoneController = TextEditingController();
// //   TextEditingController addressController = TextEditingController();

// //   File? _selectedImage;
// //   final ImagePicker _imagePicker = ImagePicker();

// //   bool _isNotValidate = false;

// //   void registerUser() async {
// //     if (!_areFieldsEmpty()) {
// //       var reqBody = {
// //         "name": nameController.text,
// //         "email": emailController.text,
// //         "password": passwordController.text,
// //         "phone": phoneController.text,
// //         "address": addressController.text,
// //         // Add other fields as needed
// //       };

// //       var response = await http.post(
// //         Uri.parse(registration),
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode(reqBody),
// //       );
// //     } else {
// //       setState(() {
// //         _isNotValidate = true;
// //       });
// //     }
// //   }

// //   bool _areFieldsEmpty() {
// //     return nameController.text.isEmpty ||
// //         emailController.text.isEmpty ||
// //         passwordController.text.isEmpty ||
// //         confirmPasswordController.text.isEmpty ||
// //         phoneController.text.isEmpty ||
// //         addressController.text.isEmpty ||
// //         _selectedImage == null;
// //   }

// //   Future<void> _pickImage() async {
// //     final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

// //     if (pickedFile != null) {
// //       setState(() {
// //         _selectedImage = File(pickedFile.path);
// //       });
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         body: Container(
// //           width: MediaQuery.of(context).size.width,
// //           height: MediaQuery.of(context).size.height,
// //           decoration: BoxDecoration(
// //             color: Colors.white, // Set background color to white
// //           ),
// //           child: Center(
// //             child: SingleChildScrollView(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: <Widget>[
// //                   GestureDetector(
// //                     onTap: _pickImage,
// //                     child: _selectedImage != null
// //                         ? CircleAvatar(
// //                             radius: 50,
// //                             backgroundImage: FileImage(_selectedImage!),
// //                           )
// //                         : Image(image: AssetImage("images/icons8-indoor-parking-48.png")),
// //                   ),
// //                   HeightBox(10),
// //                   "CREATE YOUR ACCOUNT".text.size(22).green200.make(),
// //                   TextField(
// //                     controller: nameController,
// //                     keyboardType: TextInputType.text,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       hintText: "Name",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
// //                       ),
// //                     ),
// //                   ).p4().px24(),
// //                   TextField(
// //                     controller: emailController,
// //                     keyboardType: TextInputType.emailAddress,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       hintText: "Email",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
// //                       ),
// //                     ),
// //                   ).p4().px24(),
// //                   TextField(
// //                     controller: passwordController,
// //                     obscureText: true,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       hintText: "Password",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
// //                       ),
// //                     ),
// //                   ).p4().px24(),
// //                   TextField(
// //                     controller: confirmPasswordController,
// //                     obscureText: true,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       hintText: "Confirm Password",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
// //                       ),
// //                     ),
// //                   ).p4().px24(),
// //                   TextField(
// //                     controller: phoneController,
// //                     keyboardType: TextInputType.phone,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       hintText: "Phone Number",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
// //                       ),
// //                     ),
// //                   ).p4().px24(),
// //                   TextField(
// //                     controller: addressController,
// //                     keyboardType: TextInputType.text,
// //                     decoration: InputDecoration(
// //                       filled: true,
// //                       fillColor: Colors.white,
// //                       hintText: "Address",
// //                       border: OutlineInputBorder(
// //                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
// //                       ),
// //                     ),
// //                   ).p4().px24(),

// //                   HStack([
// //                     GestureDetector(
// //                       onTap: () => {print("signin"), registerUser()},
// //                       child: VxBox(
// //                         child: "Register".text.white.makeCentered().p16(),
// //                       ).green600.roundedLg.make().px16().py16(),
// //                     ),
// //                   ]),
// //                   GestureDetector(
// //                     onTap: () {
// //                       print("Sign In");
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (context) => SignInPage()),
// //                       );
// //                     },
// //                     child: HStack([
// //                       "Already Registered?".text.make(),
// //                       " Sign In".text.white.make(),
// //                     ]).centered(),
// //                   )
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:velocity_x/velocity_x.dart';
// import 'package:http/http.dart' as http;
// import 'config.dart';
// import 'loginPage.dart';
// import 'package:image_picker/image_picker.dart';

// class Registration extends StatefulWidget {
//   @override
//   _RegistrationState createState() => _RegistrationState();
// }

// class _RegistrationState extends State<Registration> {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmPasswordController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController addressController = TextEditingController();

//   File? _selectedImage;
//   final ImagePicker _imagePicker = ImagePicker();

//   bool _isNotValidate = false;

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await _imagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   void _uploadImage() {
//     // Implement image upload logic here
//     if (_selectedImage != null) {
//       // Perform actions to upload the image, e.g., send it to a server
//       print('Image uploaded');
//     } else {
//       // Handle the case where no image is selected
//       print('No image selected');
//     }
//   }

//   void registerUser() async {
//   print("Registering user...");

//   if (!_areFieldsEmpty()) {
//     var reqBody = {
//       "name": nameController.text,
//       "email": emailController.text,
//       "password": passwordController.text,
//       "phone": phoneController.text,
//       "address": addressController.text,
//       // Add other fields as needed
//     };

//     try {
//       var response = await http.post(
//         Uri.parse(registration),
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(reqBody),
//       );

//       print("Response status: ${response.statusCode}");
//       print("Response body: ${response.body}");

//       if (response.statusCode == 200) {
//         // Registration successful
//         print("User registered successfully");
//       } else {
//         // Registration failed
//         print("User registration failed");
//       }
//     } catch (e) {
//       // Handle errors
//       print("Error during registration: $e");
//     }
//   } else {
//     setState(() {
//       _isNotValidate = true;
//       print("Validation failed");
//     });
//   }
// }

//   bool _areFieldsEmpty() {
//     return nameController.text.isEmpty ||
//         emailController.text.isEmpty ||
//         passwordController.text.isEmpty ||
//         confirmPasswordController.text.isEmpty ||
//         phoneController.text.isEmpty ||
//         addressController.text.isEmpty ||
//         _selectedImage == null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           decoration: BoxDecoration(
//             color: Colors.white, // Set background color to white
//           ),
//           child: Center(
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   GestureDetector(
//                     onTap: _pickImage,
//                     child: _selectedImage != null
//                         ? CircleAvatar(
//                             radius: 50,
//                             backgroundImage: FileImage(_selectedImage!),
//                           )
//                         : Image(
//                             image: AssetImage(
//                                 "images/icons8-indoor-parking-48.png")),
//                   ),
//                   ElevatedButton(
//                     onPressed: _pickImage,
//                     child: Text('Choose Image'),
//                   ),
//                   ElevatedButton(
//                     onPressed: _uploadImage,
//                     child: Text('Upload Image'),
//                   ),
//                   HeightBox(10),
//                   "CREATE YOUR ACCOUNT".text.size(22).green200.make(),
//                   TextField(
//                     controller: nameController,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Name",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                       ),
//                     ),
//                   ).p4().px24(),
//                   TextField(
//                     controller: emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Email",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                       ),
//                     ),
//                   ).p4().px24(),
//                   TextField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Password",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                       ),
//                     ),
//                   ).p4().px24(),
//                   TextField(
//                     controller: confirmPasswordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Confirm Password",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                       ),
//                     ),
//                   ).p4().px24(),
//                   TextField(
//                     controller: phoneController,
//                     keyboardType: TextInputType.phone,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Phone Number",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                       ),
//                     ),
//                   ).p4().px24(),
//                   TextField(
//                     controller: addressController,
//                     keyboardType: TextInputType.text,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       hintText: "Address",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                       ),
//                     ),
//                   ).p4().px24(),
//                   HStack([
//                     GestureDetector(
//                       onTap: () => {print("signin"), registerUser()},
//                       child: VxBox(
//                         child: "Register".text.white.makeCentered().p16(),
//                       ).green600.roundedLg.make().px16().py16(),
//                     ),
//                   ]),
//                   GestureDetector(
//                     onTap: () {
//                       print("Sign In");
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => SignInPage()),
//                       );
//                     },
//                     child: HStack([
//                       "Already Registered?".text.make(),
//                       " Sign In".text.white.make(),
//                     ]).centered(),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'applogo.dart';
import 'loginPage.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  void registerUser() async {
    print(passwordController.text.isEmpty);
    if (!emailController.text.isEmpty && !passwordController.text.isEmpty) {
      var reqBody = {
        "email": emailController.text,
        "password": passwordController.text
      };

      var response = await http.post(
        Uri.parse(registration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody),
      );
    } else {
      setState(() {
        _isNotValidate = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            color: Colors.white, // Set background color to white
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(
                      image: AssetImage("images/icons8-indoor-parking-48.png")),
                  HeightBox(10),
                  "CREATE YOUR ACCOUNT".text.size(22).green200.make(),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      hintText: "Email",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  TextField(
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(Icons.copy),
                        onPressed: () {
                          final data =
                              ClipboardData(text: passwordController.text);
                          Clipboard.setData(data);
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: Icon(Icons.password),
                        onPressed: () {
                          String passGen = generatePassword();
                          passwordController.text = passGen;
                          setState(() {});
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      errorStyle: TextStyle(color: Colors.white),
                      errorText: _isNotValidate ? "Enter Proper Info" : null,
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ).p4().px24(),
                  HStack([
                    GestureDetector(
                      onTap: () => {print("signin"), registerUser()},
                      child: VxBox(
                        child: "Register".text.white.makeCentered().p16(),
                      ).green600.roundedLg.make().px16().py16(),
                    ),
                  ]),
                  GestureDetector(
                    onTap: () {
                      print("Sign In");
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignInPage()),
                      );
                    },
                    child: HStack([
                      "Already Registered?".text.make(),
                      " Sign In".text.white.make(),
                    ]).centered(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String generatePassword() {
  String upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  String lower = 'abcdefghijklmnopqrstuvwxyz';
  String numbers = '1234567890';
  String symbols = '!@#\$%^&*()<>,./';

  String password = '';

  int passLength = 20;

  String seed = upper + lower + numbers + symbols;

  List<String> list = seed.split('').toList();

  Random rand = Random();

  for (int i = 0; i < passLength; i++) {
    int index = rand.nextInt(list.length);
    password += list[index];
  }
  return password;
}
