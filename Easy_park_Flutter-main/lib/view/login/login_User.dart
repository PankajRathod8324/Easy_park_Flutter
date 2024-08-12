import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/login/add_vehicle_view.dart';
<<<<<<< HEAD
// import 'package:easy_park_app/view/login/registrationOwner.dart';
import 'package:easy_park_app/view/login/registrationUser.dart';
import 'package:easy_park_app/view/Profile/my_vehicle_view.dart';
=======
import 'package:easy_park_app/view/login/profileOwner.dart';
import 'package:easy_park_app/view/login/registrationUser.dart';
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  bool isEmailValid = true;
  bool isPasswordVisible = false;

  // Function to validate email format
  String? _validateEmail(String value) {
    bool isValid = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
        .hasMatch(value.trim());
    setState(() {
      isEmailValid = isValid;
    });
    return isValid ? null : 'Enter a valid email address';
  }

  // Function to determine the text color based on email validation
  Color _getEmailTextColor(String value) {
    return _validateEmail(value) == null ? Colors.green : Colors.red;
  }

  Future<void> _login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

<<<<<<< HEAD
    // Check for email and password validity
    if (!isEmailValid || password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter correct input'),
        ),
      );
      return;
    }

=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
    try {
      final response = await http.post(
        Uri.parse(loginUser),
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        print('Login successful');
<<<<<<< HEAD
        // final response2 = await http.get(
        // Uri.parse(removeOldBookings),
        // );
        print(response);
        // if (response2 == '200') {
        //   print(response);
        // }
        // Save the email in local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userEmail', email);
        print('---------------------------------Randome');
        print(email);
=======

        // Save the email in local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userEmail', email);
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
<<<<<<< HEAD
            builder: (context) => MyVehicleView(),
=======
            builder: (context) => AddVehicleView(),
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
          ),
        );
      } else {
        print('Login failed. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
<<<<<<< HEAD
            content: Text('Wrong credentials. Please try again.'),
            backgroundColor: Colors.red,
=======
            content: Text('Login failed. Please check your credentials.'),
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
          ),
        );
      }
    } catch (e) {
      print('Error during login: $e');
<<<<<<< HEAD
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
=======
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
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
<<<<<<< HEAD
          'Login For User',
=======
          'Login To Your Account',
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: isEmailValid ? null : 'Enter a valid email address',
              ),
              onChanged: (value) {
                _validateEmail(value);
              },
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
<<<<<<< HEAD
=======
              // obscureText: true,/
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
              obscureText: !isPasswordVisible,
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationUser()),
                );
              },
              child: Text('Create an account'),
            ),
          ],
        ),
      ),
    );
  }
}
