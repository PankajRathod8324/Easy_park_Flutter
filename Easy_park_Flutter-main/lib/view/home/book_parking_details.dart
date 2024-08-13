import 'package:flutter/material.dart';
import 'package:easy_park_app/view/home/payment.dart';
import 'package:easy_park_app/view/home/pick_spot.dart';

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
  TimeOfDay selectedStartTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 10, minute: 0);
  double startHour = 9.0;
  double endHour = 10.0;
  double selectedDuration = 1.0;

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
            // Section 1: Date Selection
            Text("Select Date"),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text("Select Date"),
            ),
            SizedBox(height: 16),
            // Section 2: Duration Panel
            Text("Select Duration (Hours)"),
            _buildDurationSlider(),
            SizedBox(height: 16),
            // Section 3: Start and End Hour
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
            SizedBox(height: 8),
            Text("End Hour: ${selectedEndTime.format(context)}"),
            SizedBox(height: 16),
            // Section 4: Total Price
            Text("Total Price"),
            _buildTotalPrice(),
            SizedBox(height: 16),
            // Section 5: Continue Button
            ElevatedButton(
              onPressed: () {
                _calculateTotalCost();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      // Pass required data to PaymentScreen
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

  Widget _buildDurationSlider() {
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

  Widget _buildHourButton(String label, TimeOfDay time, VoidCallback onPressed) {
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

  Future<void> _selectTime(BuildContext context, TimeOfDay initialTime,
      ValueChanged<TimeOfDay> onChanged) async {
    final TimeOfDay picked = (await showTimePicker(
          context: context,
          initialTime: initialTime,
        )) ??
        initialTime;

    if (picked != null && picked != initialTime) {
      onChanged(picked);
    }
  }

  void _updateEndTime() {
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
}
