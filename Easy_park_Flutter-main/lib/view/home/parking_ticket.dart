import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'review_screen.dart'; // Adjust the import based on your file structure

class ParkingTicketScreen extends StatefulWidget {
  final Map<String, dynamic> vehicleData;
  final Map<String, dynamic>? matchingParkArea;
  final Map<String, dynamic> bookingData;
  final String selectedSpot;
  final Map<String, dynamic> userData;

  const ParkingTicketScreen({
    Key? key,
    required this.vehicleData,
    required this.matchingParkArea,
    required this.bookingData,
    required this.selectedSpot,
    required this.userData,
  }) : super(key: key);

  @override
  _ParkingTicketScreenState createState() => _ParkingTicketScreenState();
}

class _ParkingTicketScreenState extends State<ParkingTicketScreen> {
  late String qrCodeData;

  @override
  void initState() {
    super.initState();
    print(widget.bookingData);
    print(widget.matchingParkArea);
    print(widget.selectedSpot);
    print(widget.vehicleData);
    // Uncomment if QR code functionality is needed
    // generateQRCode('${widget.userData['name']} - ${widget.vehicleData['brand']}');
  }

  // Uncomment if QR code functionality is needed
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
              // Uncomment if QR code functionality is needed
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
                        subtitle: Text(widget.userData['name'] ?? 'N/A'),
                      ),
                      ListTile(
                        title: Text('Vehicle:'),
                        subtitle: Text(widget.vehicleData['brand'] ?? 'N/A'),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        title: Text('Park Area:'),
                        subtitle: Text(widget.matchingParkArea?['name'] ?? 'N/A'),
                      ),
                      ListTile(
                        title: Text('Park Spot:'),
                        subtitle: Text(widget.selectedSpot),
                      ),
                      ListTile(
                        title: Text('Start Time:'),
                        subtitle: Text(widget.bookingData['startTime'] ?? 'N/A'),
                      ),
                      ListTile(
                        title: Text('End Time:'),
                        subtitle: Text(widget.bookingData['endTime'] ?? 'N/A'),
                      ),
                      ListTile(
                        title: Text('Date:'),
                        subtitle: Text(widget.bookingData['bookingDate'] ?? 'N/A'),
                      ),
                      ListTile(
                        title: Text('Phone:'),
                        subtitle: Text(widget.userData['phone'] ?? 'N/A'),
                      ),
                      SizedBox(height: 16),
                      TextButton(
                        onPressed: () {
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
      ),
    );
  }
}
