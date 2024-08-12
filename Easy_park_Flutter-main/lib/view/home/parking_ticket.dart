<<<<<<< HEAD
import 'package:easy_park_app/view/home/review_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ParkingTicketScreen extends StatefulWidget {
  final Map<String, dynamic> vehicleData;
  final Map<String, dynamic>? matchingParkArea;
  final Map<String, dynamic> bookingData;
  final String selectedSpot;
  final Map<String, dynamic> userData;

  const ParkingTicketScreen(
      {super.key,
      required this.vehicleData,
      required this.matchingParkArea,
      required this.bookingData,
      required this.selectedSpot,
      required this.userData});

  @override
  _ParkingTicketScreenState createState() => _ParkingTicketScreenState();
}

class _ParkingTicketScreenState extends State<ParkingTicketScreen> {
  late String qrCodeData;
  String userName = "john";
  String vehicleNumber = "ckdnkd";

  @override
  void initState() {
    super.initState();
    print(widget.bookingData);
    print(widget.matchingParkArea);
    print(widget.selectedSpot);
    print(widget.vehicleData);
    // generateQRCode('${userName} - ${vehicleNumber}');
  }

  // Future<void> generateQRCode(String data) async {
  //   String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
  //       '#ff6666', 'Cancel', true, ScanMode.QR);

  //   setState(() {
  //     qrCodeData = barcodeScanRes;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking Ticket', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 8.0),
              //   child: Text(
              //     'Scan this on the scanner machine when you are in the parking lot',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 16,
              //       color: Colors.grey,
              //     ),
              //   ),
              // ),
              // Card(
              //   elevation: 2.0,
              //   child: Padding(
              //     padding: const EdgeInsets.all(16.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.stretch,
              //       children: [
              //         Text(
              //           'QR Code',
              //           textAlign: TextAlign.center,
              //           style: TextStyle(
              //             fontSize: 20,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         SizedBox(height: 10),
              //         Center(
              //           child: qrCodeData != null
              //               ? Image.network(
              //                   'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=$qrCodeData')
              //               : CircularProgressIndicator(),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Card(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                      ListTile(
                        title: Text('Name:'),
                        subtitle: Text(widget.userData['name']),
                      ),
                      ListTile(
                        title: Text('Vehicle:'),
                        subtitle: Text(widget.vehicleData['brand']),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        title: Text('Park Area:'),
                        subtitle: Text(widget.matchingParkArea?['name']),
                      ),
                      ListTile(
                        title: Text('Park Spot:'),
                        subtitle: Text(widget.selectedSpot),
                      ),
                      ListTile(
                        title: Text('Start Time:'),
                        subtitle: Text(widget.bookingData['startTime']),
                      ),
                      ListTile(
                        title: Text('End Time:'),
                        subtitle: Text(widget.bookingData['endTime']),
                      ),
                      ListTile(
                        title: Text('Date:'),
                        subtitle: Text(widget.bookingData['bookingDate']),
                      ),
                      ListTile(
                        title: Text('Phone:'),
                        subtitle: Text(widget.userData['phone']),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
                          // Implement the continue button action
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReviewScreen(
                                bookingData: widget.bookingData,
                                vehicleData: widget.vehicleData,
                                matchingParkArea: widget.matchingParkArea,
                                userData: widget.userData,
                              ),
                            ),
                          );
                        },
                        child: Text('Continue'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
=======
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Parking Ticket'),
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button press
            },
          ),
        ),
        body: ParkingTicketScreen(),
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
      ),
    );
  }
}
<<<<<<< HEAD
=======

class ParkingTicketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Scan this on the scanner machine when you are in the parking lot',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          Image.asset('assets/img/paytm.png', width: 200, height: 200),
          SizedBox(height: 20.0),
          TicketInfoSection(),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              // Navigate to parking lot screen
            },
            child: Text('Navigate to Parking Lot'),
          ),
        ],
      ),
    );
  }

  Widget TicketInfoSection() {
    // Replace the following with your data
    String name = 'John Doe';
    String vehicleName = 'Car';
    String parkingArea = 'Main Parking';
    String parkingSpot = 'A08';
    String duration = '2 hours';
    String date = 'March 10, 2024';
    String hours = '12:00 PM - 2:00 PM';
    String phone = '123-456-7890';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TicketInfoRow('Name', name),
        TicketInfoRow('Vehicle Name', vehicleName),
        TicketInfoRow('Parking Area', parkingArea),
        TicketInfoRow('Parking Spot', parkingSpot),
        TicketInfoRow('Duration', duration),
        TicketInfoRow('Date', date),
        TicketInfoRow('Hours', hours),
        TicketInfoRow('Phone', phone),
      ],
    );
  }

  Widget TicketInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    );
  }
}
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
