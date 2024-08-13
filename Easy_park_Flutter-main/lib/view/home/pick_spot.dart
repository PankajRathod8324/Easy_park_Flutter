import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:easy_park_app/view/home/payment1.dart';
import 'package:easy_park_app/view/config/config.dart';

class PickSpot extends StatefulWidget {
  final String totalPrice;
  final Map<String, dynamic> bookingData;
  final Map<String, dynamic>? matchingParkArea;
  final Map<String, dynamic> vehicleData;
  final Map<String, dynamic> userData;

  const PickSpot({
    Key? key,
    required this.totalPrice,
    required this.bookingData,
    required this.vehicleData,
    required this.matchingParkArea,
    required this.userData,
  }) : super(key: key);

  @override
  _PickSpotState createState() => _PickSpotState();
}

class _PickSpotState extends State<PickSpot> {
  String selectedFloor = '1st Floor';
  String selectedSpot = '';
  List<String> bookedSlots = [];

  Map<String, List<String>> allParkingSpots = {
    '1st Floor': [],
    '2nd Floor': [],
    '3rd Floor': [],
  };

  @override
  void initState() {
    super.initState();
    generateParkingSpots();
    fetchBookedSlots();
  }

  void generateParkingSpots() {
    int totalSlots = widget.matchingParkArea?['slots'] ?? 0;
    int totalFloors = 3;
    int slotsPerFloor = totalSlots ~/ totalFloors;
    int extraSlots = totalSlots % totalFloors;

    allParkingSpots = {
      '1st Floor': List.generate(slotsPerFloor + (extraSlots >= 1 ? 1 : 0),
          (index) => 'A${index + 1}'),
      '2nd Floor': List.generate(slotsPerFloor + (extraSlots >= 2 ? 1 : 0),
          (index) => 'B${index + 1}'),
      '3rd Floor': List.generate(slotsPerFloor + (extraSlots >= 3 ? 1 : 0),
          (index) => 'C${index + 1}'),
    };

    updateCurrentFloorParkingSpots();
  }

  Future<void> fetchBookedSlots() async {
    try {
      var url = Uri.parse(
          '$getunAvailableSlots?parkAreaId=${widget.matchingParkArea?['id']}&startTime=${widget.bookingData['startTime']}&endTime=${widget.bookingData['endTime']}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          bookedSlots = List<String>.from(data['bookedSlots']);
        });
      } else {
        // Handle error
        print(
            'Failed to fetch booked slots. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle error
      print('Error fetching booked slots: $error');
    }
  }

  void updateCurrentFloorParkingSpots() {
    // No need to update current floor parking spots here since we're assigning slots directly
  }

  Widget _buildTotalPrice() {
    return Text("\$${widget.totalPrice}");
  }

  Widget floorButton(String text, bool isSelected) {
    return ElevatedButton(
      onPressed: () => selectFloor(text),
      style: ElevatedButton.styleFrom(
        primary: isSelected ? Colors.pink : Colors.white,
        onPrimary: isSelected ? Colors.white : Colors.black,
      ),
      child: Text(text),
    );
  }

  void selectFloor(String floor) {
    setState(() {
      selectedFloor = floor;
    });
  }

  void selectParkingSpot(String spot) {
    if (!bookedSlots.contains(spot)) {
      setState(() {
        selectedSpot = spot;
        print('Selected Spot: $selectedSpot - $selectedFloor');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Parking Spot', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                floorButton('1st Floor', selectedFloor == '1st Floor'),
                floorButton('2nd Floor', selectedFloor == '2nd Floor'),
                floorButton('3rd Floor', selectedFloor == '3rd Floor'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: allParkingSpots[selectedFloor]?.length ?? 0,
                itemBuilder: (context, index) {
                  String spot = allParkingSpots[selectedFloor]![index];
                  return GestureDetector(
                    onTap: () {
                      selectParkingSpot(spot);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: bookedSlots
                                .contains(spot) // Check if spot is booked
                            ? Colors.grey // If booked, show as grey
                            : selectedSpot == spot
                                ? Colors.red
                                : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: selectedSpot == spot
                            ? Icon(Icons.directions_car, color: Colors.white)
                            : Text(
                                spot,
                                style: TextStyle(
                                  color: selectedSpot == spot
                                      ? Colors.transparent
                                      : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedSpot.isNotEmpty
                  ? () {
                      // Create ticket data
                      Map<String, dynamic> ticketData = {
                        'bookingdetails': widget.bookingData,
                        'parkingSlot': selectedSpot,
                        'amount': widget.totalPrice,
                      };
                      print('------------------------');
                      print(ticketData);

                      // Navigate to the payment screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen1(
                            selectedSpot: selectedSpot,
                            bookingData: widget.bookingData,
                            vehicleData: widget.vehicleData,
                            matchingParkArea: widget.matchingParkArea,
                            totalPrice: widget.totalPrice,
                            userData: widget.userData,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Text('Continue'),
            ),
          ),
          Text('Total Price: \$${widget.totalPrice}'),
        ],
      ),
    );
  }
}
