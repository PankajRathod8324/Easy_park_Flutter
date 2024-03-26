// import 'package:flutter/material.dart';

// class DisplayJson extends StatelessWidget {
//   final Map<String, dynamic>? jsonData;

//   const DisplayJson({Key? key, required this.jsonData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('JSON Data'),
//       ),
//       body: jsonData != null && jsonData!.isNotEmpty
//           ? ListView(
//               children: [
//                 ListTile(
//                   title: Text('Address'),
//                   subtitle: Text(jsonData!['address'].toString()),
//                 ),
//                 ListTile(
//                   title: Text('Phone'),
//                   subtitle: Text(jsonData!['phone'].toString()),
//                 ),
//                 ListTile(
//                   title: Text('Owner Name'),
//                   subtitle: Text(jsonData!['owner']['name'].toString()),
//                 ),
//               ],
//             )
//           : Center(
//               child: Text('No JSON data available'),
//             ),
//     );
//   }
// }
import 'package:easy_park_app/view/config/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisplayJson extends StatefulWidget {
  final Map<String, dynamic>? jsonData;

  const DisplayJson({Key? key, this.jsonData}) : super(key: key);

  @override
  _DisplayJsonState createState() => _DisplayJsonState();
}

class _DisplayJsonState extends State<DisplayJson> {
  Map<String, dynamic>? jsonData;

  @override
  void initState() {
    super.initState();
    jsonData = widget.jsonData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JSON Data'),
      ),
      body: jsonData != null && jsonData!.isNotEmpty
          ? ListView(
              children: [
                ListTile(
                  title: Text('Address'),
                  subtitle: Text(jsonData!['address'].toString()),
                ),
                ListTile(
                  title: Text('Phone'),
                  subtitle: Text(jsonData!['phone'].toString()),
                ),
                ListTile(
                  title: Text('Owner Name'),
                  subtitle: Text(jsonData!['owner']['name'].toString()),
                ),
              ],
            )
          : Center(
              child:
                  CircularProgressIndicator(), // Show loading indicator while fetching data
            ),
    );
  }
}
