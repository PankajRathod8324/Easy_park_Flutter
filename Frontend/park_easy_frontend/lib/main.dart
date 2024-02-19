// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // TRY THIS: Try running your application with "flutter run". You'll see
//         // the application has a purple toolbar. Then, without quitting the app,
//         // try changing the seedColor in the colorScheme below to Colors.green
//         // and then invoke "hot reload" (save your changes or press the "hot
//         // reload" button in a Flutter-supported IDE, or press "r" if you used
//         // the command line to start the app).
//         //
//         // Notice that the counter didn't reset back to zero; the application
//         // state is not lost during the reload. To reset the state, use hot
//         // restart instead.
//         //
//         // This works for code too, not just values: Most code changes can be
//         // tested with just a hot reload.
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // TRY THIS: Try changing the color here to a specific color (to
//         // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
//         // change color while the other colors stay the same.
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           //
//           // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
//           // action in the IDE, or press "p" in the console), to see the
//           // wireframe for each widget.
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headlineMedium,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }

// registation.dart (main)
// import 'package:flutter/material.dart';
// import 'package:flutter_todo_app/dashboard.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'loginPage.dart';

// void main() async {
//    WidgetsFlutterBinding.ensureInitialized();
//    SharedPreferences prefs = await SharedPreferences.getInstance();
//   runApp(MyApp(token: prefs.getString('token'),));
// }

// class MyApp extends StatelessWidget {

//   final token;
//   const MyApp({
//     @required this.token,
//     Key? key,
// }): super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(

//         primaryColor: Colors.black,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       // home: (token != null && JwtDecoder.isExpired(token) == false )?Dashboard(token: token):SignInPage()
//       home: SignInPage()
//     );
//   }
// }

// registration.dart
// withi folder
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:park_easy_frontend/config.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController nameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

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
  if (_selectedImage != null) {
    var request = http.MultipartRequest('POST', Uri.parse(registration));
    request.fields['name'] = nameController.text;
    request.files.add(
        await http.MultipartFile.fromPath('image', _selectedImage!.path));
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('Image uploaded successfully');
        // Handle success
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        // Handle failure
      }
    } catch (e) {
      print('Error during image upload: $e');
      // Handle error
    }
  } else {
    print('No image selected');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
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
              child: Text('Upload Image'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: Registration()));
}

//direct in database

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:http/http.dart' as http;
// import 'package:park_easy_frontend/config.dart';

// class Registration extends StatefulWidget {
//   @override
//   _RegistrationState createState() => _RegistrationState();
// }

// class _RegistrationState extends State<Registration> {
//   TextEditingController nameController = TextEditingController();
//   File? _selectedImage;
//   final ImagePicker _imagePicker = ImagePicker();

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await _imagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<void> _uploadImage() async {
//     if (_selectedImage != null && nameController.text.isNotEmpty) {
//       try {
//         var request = http.MultipartRequest(
//           'POST',
//           Uri.parse(registration),
//         );
//         request.headers['Content-Type'] = 'multipart/form-data';
//         // Add 'name' and 'image' fields to the request
//         request.fields['name'] = nameController.text;

//         // Add image file
//         request.files.add(
//           await http.MultipartFile.fromPath(
//             'image',
//             _selectedImage!.path,
//             filename: 'image.jpg',
//           ),
//         );
//         print(request.files);
//         // Send the request and get the response
//         var response = await request.send();

//         // Check the response status code
//         if (response.statusCode == 200) {
//           print('Image uploaded successfully');
//           // Handle success
//         } else {
//           print('Failed to upload image. Status code: ${response.statusCode}');
//           // Handle failure
//         }
//       } catch (e) {
//         print('Error during image upload: $e');
//         // Handle error
//       }
//     } else {
//       print('Please provide a name and select an image');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Registration'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextFormField(
//               controller: nameController,
//               decoration: InputDecoration(labelText: 'Name'),
//             ),
//             SizedBox(height: 20),
//             GestureDetector(
//               onTap: _pickImage,
//               child: _selectedImage != null
//                   ? CircleAvatar(
//                       radius: 50,
//                       backgroundImage: FileImage(_selectedImage!),
//                     )
//                   : CircleAvatar(
//                       radius: 50,
//                       child: Icon(Icons.camera_alt),
//                     ),
//             ),
//             ElevatedButton(
//               onPressed: _pickImage,
//               child: Text('Choose Image'),
//             ),
//             ElevatedButton(
//               onPressed: _uploadImage,
//               child: Text('Upload Image'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(MaterialApp(home: Registration()));
// }
