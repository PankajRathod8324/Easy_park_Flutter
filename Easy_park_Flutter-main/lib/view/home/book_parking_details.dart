// import 'package:easy_park_app/view/home/pick_spot.dart';
// import 'package:flutter/material.dart';

// class BookParkingPage extends StatefulWidget {
//   final Map<String, dynamic> vehicleData;
//   final Map<String, dynamic>? matchingParkArea;
//   final Map<String, dynamic> userData;
//   const BookParkingPage({
//     Key? key,
//     required this.vehicleData,
//     this.matchingParkArea,
//     required this.userData,
//   }) : super(key: key);

//   @override
//   _BookParkingPageState createState() => _BookParkingPageState();
// }

// class _BookParkingPageState extends State<BookParkingPage> {
//   DateTime selectedDate = DateTime.now();
//   TimeOfDay selectedStartTime = TimeOfDay(hour: 0, minute: 0);
//   TimeOfDay selectedEndTime = TimeOfDay(hour: 0, minute: 0);
//   double startHour = 0;
//   double endHour = 0;
//   double selectedDuration = 1.0;
//   late String totalPrice = '';
//   late Map<String, dynamic> bookingData;

//   bool isDurationSliderChanged = false;

//   @override
//   Widget build(BuildContext context) {
//     print('------------------');
//     print(widget.matchingParkArea);
//     print(widget.userData);
//     print(widget.vehicleData);
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: Text(
//           "Book Parking Details",
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             // Section 1: Date Selection
//             Text("Select Date"),
//             ElevatedButton(
//               onPressed: () => _selectDate(context),
//               child: Text("Select Date"),
//             ),

//             // Section 2: Distance Panel
//             Text("Select Duration (Hours)"),
//             _buildDistanceBar(),

//             // Section 3: Start and End Hour
//             Text("Start Hour"),
//             _buildHourButton("Start Hour", selectedStartTime, () {
//               _selectTime(context, selectedStartTime, (time) {
//                 setState(() {
//                   selectedStartTime = time;
//                   startHour = time.hour + time.minute / 60.0;
//                 });
//               });
//             }),

//             Text("End Hour"),
//             _buildHourButton("End Hour", selectedEndTime, () {
//               _selectTime(context, selectedEndTime, (time) {
//                 setState(() {
//                   selectedEndTime = time;
//                   endHour = time.hour + time.minute / 60.0;
//                 });
//               });
//             }),

//             // Section 4: Total Price
//             Text("Total Price"),
//             _buildTotalPrice(),

//             // Section 5: Continue Button
//             ElevatedButton(
//               onPressed: () {
//                 // Handle continue button press
//                 // Calculate total cost or navigate to the next page
//                 print("Continue button pressed");
//                 _calculateTotalCost();
//                 totalPrice =
//                     ((endHour - startHour) * selectedDuration * 8.0).toString();
//                 print(totalPrice);

//                 // Initialize booking data
//                 _initializeBookingData();
//                 print(bookingData);
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => PickSpot(
//                       totalPrice: totalPrice,
//                       bookingData: bookingData,
//                       vehicleData: widget.vehicleData,
//                       matchingParkArea: widget.matchingParkArea,
//                       userData: widget.userData,
//                       // selectedDate: selectedDate,
//                       // selectedStartTime: selectedStartTime,
//                       // selectedEndTime: selectedEndTime,
//                       // selectedDuration: selectedDuration,
//                     ),
//                   ),
//                 );
//               },
//               // Use Navigator to navigate to the next page

//               child: Text("Continue"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDistanceBar() {
//     return Column(
//       children: [
//         Text("Selected Duration: ${selectedDuration.toInt()} hours"),
//         Slider(
//           value: selectedDuration,
//           min: 1.0,
//           max: 12.0,
//           divisions: 11,
//           onChanged: (value) {
//             setState(() {
//               isDurationSliderChanged = true; // Setting the flag
//               selectedDuration = value;
//               // Check if the selected duration matches the calculated duration
//               double calculatedDuration = endHour - startHour;
//               if (selectedDuration != calculatedDuration) {
//                 // Adjust the end time to match the selected duration
//                 selectedEndTime = TimeOfDay(
//                   hour:
//                       (selectedStartTime.hour + selectedDuration.toInt()) % 24,
//                   minute: selectedStartTime.minute,
//                 );
//                 endHour = selectedEndTime.hour + selectedEndTime.minute / 60.0;
//               }
//             });
//           },
//         ),
//       ],
//     );
//   }

//   Widget _buildHourButton(
//       String label, TimeOfDay time, VoidCallback onPressed) {
//     return Row(
//       children: [
//         Text(label),
//         SizedBox(width: 10),
//         ElevatedButton(
//           onPressed: onPressed,
//           child: Row(
//             children: [
//               Text("${time.format(context)}"),
//               Icon(Icons.access_time),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTotalPrice() {
//     // Assuming $8 per hour
//     double totalPrice = (endHour - startHour) * selectedDuration * 8.0;
//     return Text("\$$totalPrice");
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime now = DateTime.now();
//     final DateTime picked = (await showDatePicker(
//           context: context,
//           initialDate: selectedDate,
//           firstDate: now,
//           lastDate: DateTime(2030),
//         )) ??
//         selectedDate;

//     if (picked != null && picked != selectedDate) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
//       ValueChanged<TimeOfDay> onChanged) async {
//     final TimeOfDay now = TimeOfDay.now();
//     final TimeOfDay picked = (await showTimePicker(
//           context: context,
//           initialTime: initialTime,
//         )) ??
//         initialTime;

//     if (picked != null && picked != initialTime) {
//       if ((selectedDate.isAtSameMomentAs(DateTime.now()) &&
//               picked.hour < now.hour) ||
//           selectedDate.isBefore(DateTime.now())) {
//         // Show error message or handle appropriately for selecting past time
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Text("Please select a valid time"),
//         ));
//       } else {
//         onChanged(picked);
//       }
//     }
//   }

//   void _calculateTotalCostIfNeeded() {
//     if (isDurationSliderChanged) {
//       // Check if duration slider was changed
//       double calculatedDuration = endHour - startHour;
//       if (selectedDuration != calculatedDuration) {
//         // Duration is not matching, show an error or handle it as required
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content:
//               Text("End Hour - Start Hour should match the selected duration"),
//         ));
//         return;
//       }
//       // Proceed with calculating the total cost
//       _calculateTotalCost();
//       totalPrice = ((endHour - startHour) * selectedDuration * 8.0).toString();
//       print(totalPrice);
//       // Initialize booking data
//       _initializeBookingData();
//       print(bookingData);
//       Navigator.of(context).push(
//         MaterialPageRoute(
//           builder: (context) => PickSpot(
//             totalPrice: totalPrice,
//             bookingData: bookingData,
//             vehicleData: widget.vehicleData,
//             matchingParkArea: widget.matchingParkArea,
//             userData: widget.userData,
//           ),
//         ),
//       );
//       // Reset the flag after the calculation is done
//       isDurationSliderChanged = false;
//     }
//   }

//   void _calculateTotalCost() {
//     // Calculate and display the total cost based on the selected hours and duration
//     double totalPrice = (endHour - startHour) * selectedDuration * 8.0;
//     print("Total Price: \$$totalPrice");
//   }

//   // Initialize booking data
//   void _initializeBookingData() {
//     String formattedStartTime =
//         "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}T${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}:00Z";
//     String formattedEndTime =
//         "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}T${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}:00Z";

//     double totalPrice = (endHour - startHour) * selectedDuration * 8.0;

//     String vehicleId = widget.vehicleData['_id'];
//     String? parkAreaId = widget.matchingParkArea?['id'];

//     this.bookingData = {
//       "vehicle": vehicleId,
//       "parkArea": parkAreaId,
//       "startTime": formattedStartTime,
//       "endTime": formattedEndTime,
//       "status": "Booked",
//       "bookingDate":
//           "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
//       "totalPrice": totalPrice,
//     };

//     print('Booking Data: ${this.bookingData}');
//   }
// }

import 'package:easy_park_app/view/home/pick_spot.dart';
import 'package:flutter/material.dart';

class BookParkingPage extends StatefulWidget {
  final Map<String, dynamic> vehicleData;
  final Map<String, dynamic>? matchingParkArea;
  final Map<String, dynamic> userData;
  const BookParkingPage({
    Key? key,
    required this.vehicleData,
    this.matchingParkArea,
    required this.userData,
  }) : super(key: key);

  @override
  _BookParkingPageState createState() => _BookParkingPageState();
}

class _BookParkingPageState extends State<BookParkingPage> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 0, minute: 0);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 0, minute: 0);
  double startHour = 0;
  double endHour = 0;
  double selectedDuration = 1.0;
  late String totalPrice = '';
  late Map<String, dynamic> bookingData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          "Book Parking Details",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Select Date"),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text("Select Date"),
            ),
            Text("Select Duration (Hours)"),
            _buildDistanceBar(),
            Text("Start Hour"),
            _buildHourButton("Start Hour", selectedStartTime, () {
              _selectTime(context, selectedStartTime, (time) {
                setState(() {
                  selectedStartTime = time;
                  startHour = time.hour + time.minute / 60.0;
                  _updateEndTime(); // Update end time based on start time
                });
              });
            }),
            Text("End Hour: ${selectedEndTime.format(context)}"),
            Text("Total Price"),
            _buildTotalPrice(),
            ElevatedButton(
              onPressed: () {
                print("Continue button pressed");
                _calculateTotalCost();
                totalPrice =
                    ((endHour - startHour) * selectedDuration * 8.0).toString();
                print(totalPrice);

                _initializeBookingData();
                print(bookingData);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PickSpot(
                      totalPrice: totalPrice,
                      bookingData: bookingData,
                      vehicleData: widget.vehicleData,
                      matchingParkArea: widget.matchingParkArea,
                      userData: widget.userData,
                    ),
                  ),
                );
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistanceBar() {
    return Column(
      children: [
        Text("Selected Duration: ${selectedDuration.toInt()} hours"),
        Slider(
          value: selectedDuration,
          min: 1.0,
          max: 12.0,
          divisions: 11,
          onChanged: (value) {
            setState(() {
              selectedDuration = value;
              _updateEndTime(); // Update end time based on selected duration
            });
          },
        ),
      ],
    );
  }

  Widget _buildHourButton(
      String label, TimeOfDay time, VoidCallback onPressed) {
    return Row(
      children: [
        Text(label),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: onPressed,
          child: Row(
            children: [
              Text("${time.format(context)}"),
              Icon(Icons.access_time),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTotalPrice() {
    double totalPrice = (endHour - startHour) * selectedDuration * 8.0;
    return Text("\$$totalPrice");
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: now,
          lastDate: DateTime(2030),
        )) ??
        selectedDate;

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
  //     ValueChanged<TimeOfDay> onChanged) async {
  //   final TimeOfDay picked = (await showTimePicker(
  //         context: context,
  //         initialTime: initialTime,
  //       )) ??
  //       initialTime;

  //   if (picked != null && picked != initialTime) {
  //     if ((selectedDate.isAtSameMomentAs(DateTime.now()) &&
  //             picked.hour > DateTime.now().hour) ||
  //         !selectedDate.isBefore(DateTime.now())) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text("Please select a valid time"),
  //       ));
  //     } else {
  //       onChanged(picked);
  //     }
  //   }
  // }

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      ValueChanged<TimeOfDay> onChanged) async {
    final TimeOfDay picked = (await showTimePicker(
          context: context,
          initialTime: initialTime,
        )) ??
        initialTime;

    if (picked != null && picked != initialTime) {
      final DateTime now = DateTime.now();
      final DateTime selectedDateTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        picked.hour,
        picked.minute,
      );

      if (selectedDateTime.isAfter(now)) {
        onChanged(picked);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Please select a valid time"),
        ));
      }
    }
  }

  void _updateEndTime() {
    // Update end time based on selected duration and start time
    selectedEndTime = TimeOfDay(
      hour: (selectedStartTime.hour + selectedDuration.toInt()) % 24,
      minute: selectedStartTime.minute,
    );
    endHour = selectedEndTime.hour + selectedEndTime.minute / 60.0;
  }

  void _calculateTotalCost() {
    double totalPrice = (endHour - startHour) * selectedDuration * 8.0;
    print("Total Price: \$$totalPrice");
  }

  void _initializeBookingData() {
    String formattedStartTime =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}T${selectedStartTime.hour.toString().padLeft(2, '0')}:${selectedStartTime.minute.toString().padLeft(2, '0')}:00Z";
    String formattedEndTime =
        "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}T${selectedEndTime.hour.toString().padLeft(2, '0')}:${selectedEndTime.minute.toString().padLeft(2, '0')}:00Z";

    double totalPrice = (endHour - startHour) * selectedDuration * 8.0;

    String vehicleId = widget.vehicleData['_id'];
    String? parkAreaId = widget.matchingParkArea?['id'];

    this.bookingData = {
      "vehicle": vehicleId,
      "parkArea": parkAreaId,
      "startTime": formattedStartTime,
      "endTime": formattedEndTime,
      "status": "Booked",
      "bookingDate":
          "${selectedDate.month}/${selectedDate.day}/${selectedDate.year}",
      "totalPrice": totalPrice,
    };

    print('Booking Data: ${this.bookingData}');
  }
}
