<<<<<<< HEAD
import 'dart:convert';

import 'package:easy_park_app/view/config/config.dart';
import 'package:easy_park_app/view/home/payment1.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  // void extractBookedSlots() {
  //   List<dynamic>? slots = widget.matchingParkArea?['booked_slot'];
  //   if (slots != null) {
  //     bookedSlots = slots.map((slot) => slot.toString()).toList();
  //   }
  // }
  Future<void> fetchBookedSlots() async {
    try {
      print(widget.matchingParkArea);
      // Replace 'your_backend_api_endpoint' with your actual endpoint
      var url = Uri.parse(
          '$getunAvailableSlots?parkAreaId=${widget.matchingParkArea?['id']}&startTime=${widget.bookingData['startTime']}&endTime=${widget.bookingData['endTime']}');
      print("-------------------------------");
      print(url);
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

  // Future<void> sendTicketDataToBackend(Map<String, dynamic> ticketData) async {
  //   try {
  //     var url = Uri.parse(bookparking); // Replace with your actual endpoint
  //     var response = await http.post(
  //       url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(ticketData),
  //     );

  //     if (response.statusCode == 201) {
  //       // Ticket created successfully
  //       print('Ticket created successfully');
  //     } else {
  //       // Handle error
  //       print('Failed to create ticket. Status code: ${response.statusCode}');
  //     }
  //   } catch (error) {
  //     // Handle error
  //     print('Error sending ticket data: $error');
  //   }
  // }

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
    _buildTotalPrice();
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
                itemCount: allParkingSpots[selectedFloor]!.length,
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

                      // Send ticket data to the backend
                      // sendTicketDataToBackend(ticketData);
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
=======
import 'package:flutter/material.dart';

class PickSpotScreen extends StatefulWidget {
  const PickSpotScreen({Key? key}) : super(key: key);

  @override
  _PickSpotScreenState createState() => _PickSpotScreenState();
}

class _PickSpotScreenState extends State<PickSpotScreen> {
  List<bool> isSpotOccupied = List.generate(12, (index) => false);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChipView(context),
            SizedBox(height: 36.0),
            Padding(
              padding: EdgeInsets.only(left: 40.0),
              child: Text("Entry", style: Theme.of(context).textTheme.headline6),
            ),
            SizedBox(height: 3.0),
            _buildParkingLayout(context),
            SizedBox(height: 5.0),
          ],
        ),
        bottomNavigationBar: _buildButton(context),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text("Pick Parking Spot"),
    );
  }

  Widget _buildChipView(BuildContext context) {
    return Wrap(
      runSpacing: 19.0,
      spacing: 19.0,
      children: List.generate(3, (index) => Chipview2ItemWidget()),
    );
  }

  Widget _buildParkingLayout(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 4.0, right: 21.0),
      child: Row(
        children: [
          _buildParkingRow(0, 6),
          SizedBox(width: 40.0),
          _buildParkingRow(6, 12),
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
        ],
      ),
    );
  }
<<<<<<< HEAD
}
=======

  Widget _buildParkingRow(int start, int end) {
    return Row(
      children: List.generate(end - start, (index) {
        int spotNumber = start + index + 1;
        return GestureDetector(
          onTap: () {
            _onParkingSpotTap(spotNumber - 1);
          },
          child: Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: isSpotOccupied[start + index]
                  ? Colors.redAccent
                  : Colors.green,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: isSpotOccupied[start + index]
                  ? Icon(Icons.abc_rounded, color: Colors.white)
                  : Text(
                      spotNumber.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
            ),
          ),
        );
      }),
    );
  }

  void _onParkingSpotTap(int index) {
    setState(() {
      isSpotOccupied[index] = !isSpotOccupied[index];
    });
  }

  Widget _buildButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Implement your logic when Continue button is pressed
      },
      child: Text("Continue"),
    );
  }
}

class Chipview2ItemWidget extends StatelessWidget {
  const Chipview2ItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RawChip(
      padding: EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 6.0,
      ),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        "1st Floor",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary.withOpacity(1),
          fontSize: 16.0,
          fontFamily: 'Jost',
          fontWeight: FontWeight.w600,
        ),
      ),
      selected: false,
      backgroundColor: Theme.of(context).colorScheme.onPrimary.withOpacity(1),
      selectedColor: Theme.of(context).colorScheme.primary,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(18.0),
      ),
      onSelected: (value) {},
    );
  }
}


// import 'package:easy_park_app/common_widget/app_export.dart';
// import 'package:easy_park_app/common_widget/widgets/app_bar/appbar_leading_image.dart';
// import 'package:easy_park_app/common_widget/widgets/app_bar/appbar_subtitle.dart';
// import 'package:easy_park_app/common_widget/widgets/app_bar/custom_app_bar.dart';
// import 'package:easy_park_app/common_widget/widgets/custom_elevated_button.dart';
// import 'package:easy_park_app/common_widget/widgets/custom_outlined_button.dart';
// import 'package:easy_park_app/common_widget/widgets/custom_text_form_field.dart';
// // import 'package:easy_park_app/common_widget/utils/image_constant.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg_provider/flutter_svg_provider.dart' as fs;

// // ignore_for_file: must_be_immutable
// class PickSpotcreen extends StatelessWidget {
//   PickSpotcreen({Key? key}) : super(key: key);


//   TextEditingController avalueController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             resizeToAvoidBottomInset: false,
//             appBar: _buildAppBar(context),
//             body: Container(
//                 width: double.maxFinite,
//                 padding: EdgeInsets.symmetric(horizontal: 28.h, vertical: 14.v),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildChipView(context),
//                       SizedBox(height: 36.v),
//                       Padding(
//                           padding: EdgeInsets.only(left: 40.h),
//                           child:
//                               Text("Entry", style: theme.textTheme.titleLarge)),
//                       SizedBox(height: 3.v),
//                       Padding(
//                           padding: EdgeInsets.only(left: 4.h, right: 21.h),
//                           child: Row(children: [
//                             Container(
//                                 width: 14.h,
//                                 margin:
//                                     EdgeInsets.only(top: 103.v, bottom: 107.v),
//                                 child: Text("2 Way traffic".toUpperCase(),
//                                     maxLines: 11,
//                                     overflow: TextOverflow.ellipsis,
//                                     style: CustomTextStyles
//                                         .titleMediumGray500Medium
//                                         .copyWith(height: 1.98))),
//                             Expanded(
//                                 child: Padding(
//                                     padding: EdgeInsets.only(left: 31.h),
//                                     child: Column(children: [
//                                       Padding(
//                                           padding: EdgeInsets.only(right: 3.h),
//                                           child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: [
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         bottom: 4.v),
//                                                     child: Column(children: [
//                                                       CustomImageView(
//                                                           imagePath:
//                                                               ImageConstant
//                                                                   .imgLightBulb,
//                                                           height: 39.v,
//                                                           width: 14.h),
//                                                       SizedBox(height: 11.v),
//                                                       SizedBox(
//                                                           height: 47.v,
//                                                           child: VerticalDivider(
//                                                               width: 2.h,
//                                                               thickness: 2.v,
//                                                               color: appTheme
//                                                                   .gray500)),
//                                                       SizedBox(height: 18.v),
//                                                       SizedBox(
//                                                           height: 47.v,
//                                                           child: VerticalDivider(
//                                                               width: 2.h,
//                                                               thickness: 2.v,
//                                                               color: appTheme
//                                                                   .gray500)),
//                                                       SizedBox(height: 18.v),
//                                                       SizedBox(
//                                                           height: 47.v,
//                                                           child: VerticalDivider(
//                                                               width: 2.h,
//                                                               thickness: 2.v,
//                                                               color: appTheme
//                                                                   .gray500))
//                                                     ])),
//                                                 _buildStack(context)
//                                               ])),
//                                       SizedBox(height: 14.v),
//                                       Container(
//                                           width: 287.h,
//                                           margin: EdgeInsets.symmetric(
//                                               horizontal: 7.h),
//                                           child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.end,
//                                               children: [
//                                                 SizedBox(
//                                                     height: 47.v,
//                                                     child: VerticalDivider(
//                                                         width: 2.h,
//                                                         thickness: 2.v,
//                                                         color:
//                                                             appTheme.gray500)),
//                                                 Spacer(),
//                                                 CustomImageView(
//                                                     imagePath: ImageConstant
//                                                         .imgArrowLeft,
//                                                     height: 14.v,
//                                                     width: 39.h,
//                                                     margin: EdgeInsets.only(
//                                                         top: 24.v,
//                                                         bottom: 9.v)),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         top: 29.v,
//                                                         bottom: 16.v),
//                                                     child: SizedBox(
//                                                         width: 64.h,
//                                                         child: Divider(
//                                                             color: appTheme
//                                                                 .gray500,
//                                                             indent: 17.h))),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         top: 29.v,
//                                                         bottom: 16.v),
//                                                     child: SizedBox(
//                                                         width: 59.h,
//                                                         child: Divider(
//                                                             color: appTheme
//                                                                 .gray500,
//                                                             indent: 12.h))),
//                                                 Padding(
//                                                     padding: EdgeInsets.only(
//                                                         top: 29.v,
//                                                         bottom: 16.v),
//                                                     child: SizedBox(
//                                                         width: 58.h,
//                                                         child: Divider(
//                                                             color: appTheme
//                                                                 .gray500,
//                                                             indent: 11.h)))
//                                               ])),
//                                       SizedBox(height: 18.v),
//                                       Padding(
//                                           padding: EdgeInsets.only(left: 6.h),
//                                           child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: [
//                                                 Column(children: [
//                                                   SizedBox(
//                                                       height: 47.v,
//                                                       child: VerticalDivider(
//                                                           width: 2.h,
//                                                           thickness: 2.v,
//                                                           color: appTheme
//                                                               .gray500)),
//                                                   SizedBox(height: 18.v),
//                                                   SizedBox(
//                                                       height: 47.v,
//                                                       child: VerticalDivider(
//                                                           width: 2.h,
//                                                           thickness: 2.v,
//                                                           color: appTheme
//                                                               .gray500)),
//                                                   SizedBox(height: 18.v),
//                                                   SizedBox(
//                                                       height: 47.v,
//                                                       child: VerticalDivider(
//                                                           width: 2.h,
//                                                           thickness: 2.v,
//                                                           color: appTheme
//                                                               .gray500)),
//                                                   SizedBox(height: 18.v),
//                                                   SizedBox(
//                                                       height: 47.v,
//                                                       child: VerticalDivider(
//                                                           width: 2.h,
//                                                           thickness: 2.v,
//                                                           color:
//                                                               appTheme.gray500))
//                                                 ]),
//                                                 Container(
//                                                     height: 225.v,
//                                                     width: 234.h,
//                                                     margin: EdgeInsets.only(
//                                                         left: 59.h,
//                                                         top: 4.v,
//                                                         bottom: 13.v),
//                                                     child: Stack(
//                                                         alignment:
//                                                             Alignment.topCenter,
//                                                         children: [
//                                                           Align(
//                                                               alignment:
//                                                                   Alignment
//                                                                       .center,
//                                                               child: Container(
//                                                                   margin: EdgeInsets.only(
//                                                                       left: 4.h,
//                                                                       right:
//                                                                           5.h),
//                                                                   padding: EdgeInsets.symmetric(
//                                                                       vertical:
//                                                                           16.v),
//                                                                   decoration: BoxDecoration(
//                                                                       image: DecorationImage(
//                                                                           image: fs.Svg(ImageConstant
//                                                                               .imgGroup124),
//                                                                           fit: BoxFit
//                                                                               .cover)),
//                                                                   child: Column(
//                                                                       mainAxisSize:
//                                                                           MainAxisSize
//                                                                               .min,
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .center,
//                                                                       children: [
//                                                                         CustomOutlinedButton(
//                                                                             height: 36
//                                                                                 .v,
//                                                                             width: 101
//                                                                                 .h,
//                                                                             text:
//                                                                                 "A08",
//                                                                             margin:
//                                                                                 EdgeInsets.only(right: 1.h),
//                                                                             buttonStyle: CustomButtonStyles.outlinePrimaryTL10,
//                                                                             buttonTextStyle: CustomTextStyles.titleMediumBlack900_1,
//                                                                             alignment: Alignment.centerRight),
//                                                                         SizedBox(
//                                                                             height:
//                                                                                 120.v),
//                                                                         CustomTextFormField(
//                                                                             width: 101
//                                                                                 .h,
//                                                                             controller:
//                                                                                 avalueController,
//                                                                             hintText:
//                                                                                 "A11",
//                                                                             hintStyle:
//                                                                                 CustomTextStyles.titleMediumBlack900_1,
//                                                                             textInputAction: TextInputAction.done,
//                                                                             contentPadding: EdgeInsets.symmetric(horizontal: 30.h, vertical: 6.v),
//                                                                             borderDecoration: TextFormFieldStyleHelper.outlinePrimaryTL10,
//                                                                             fillColor: theme.colorScheme.primary.withOpacity(0.1))
//                                                                       ]))),
//                                                           Align(
//                                                               alignment: Alignment
//                                                                   .topCenter,
//                                                               child: Padding(
//                                                                   padding: EdgeInsets
//                                                                       .only(
//                                                                           top: 73
//                                                                               .v),
//                                                                   child: SizedBox(
//                                                                       width:
//                                                                           228.h,
//                                                                       child: Divider(
//                                                                           color:
//                                                                               appTheme.gray500)))),
//                                                           Align(
//                                                               alignment: Alignment
//                                                                   .bottomCenter,
//                                                               child: Padding(
//                                                                   padding: EdgeInsets.only(
//                                                                       bottom:
//                                                                           71.v),
//                                                                   child: SizedBox(
//                                                                       width:
//                                                                           228.h,
//                                                                       child: Divider(
//                                                                           color:
//                                                                               appTheme.gray500)))),
//                                                           CustomImageView(
//                                                               imagePath:
//                                                                   ImageConstant
//                                                                       .imgKisspngCarDoo56x107,
//                                                               height: 56.v,
//                                                               width: 107.h,
//                                                               alignment: Alignment
//                                                                   .centerRight),
//                                                           CustomImageView(
//                                                               imagePath:
//                                                                   ImageConstant
//                                                                       .imgKisspngCarDoo56x107,
//                                                               height: 56.v,
//                                                               width: 107.h,
//                                                               alignment: Alignment
//                                                                   .bottomRight,
//                                                               margin: EdgeInsets
//                                                                   .only(
//                                                                       bottom:
//                                                                           8.v)),
//                                                           CustomImageView(
//                                                               imagePath:
//                                                                   ImageConstant
//                                                                       .imgKisspngCarDoo,
//                                                               height: 56.v,
//                                                               width: 107.h,
//                                                               alignment:
//                                                                   Alignment
//                                                                       .topLeft,
//                                                               margin: EdgeInsets
//                                                                   .only(
//                                                                       top:
//                                                                           9.v)),
//                                                           CustomImageView(
//                                                               imagePath:
//                                                                   ImageConstant
//                                                                       .imgKisspngCarDoo,
//                                                               height: 56.v,
//                                                               width: 107.h,
//                                                               alignment: Alignment
//                                                                   .centerLeft)
//                                                         ]))
//                                               ]))
//                                     ])))
//                           ])),
//                       SizedBox(height: 5.v)
//                     ])),
//             bottomNavigationBar: _buildButton(context)));
//   }

//   /// Section Widget
//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return CustomAppBar(
//         leadingWidth: 59.h,
//         leading: AppbarLeadingImage(
//             imagePath: ImageConstant.imgFrameOnprimarycontainer,
//             margin: EdgeInsets.only(left: 33.h, top: 17.v, bottom: 20.v),
//             onTap: () {
//               onTapImage(context);
//             }),
//         title: AppbarSubtitle(
//             text: "Pick Parking Spot", margin: EdgeInsets.only(left: 19.h)));
//   }

//   /// Section Widget
//   Widget _buildChipView(BuildContext context) {
//     return Wrap(
//         runSpacing: 19.v,
//         spacing: 19.h,
//         children: List<Widget>.generate(3, (index) => Chipview2ItemWidget()));
//   }

//   /// Section Widget
//   Widget _buildStack(BuildContext context) {
//     return Container(
//         height: 225.v,
//         width: 231.h,
//         margin: EdgeInsets.only(left: 53.h, top: 6.v),
//         child: Stack(alignment: Alignment.center, children: [
//           Align(
//               alignment: Alignment.topLeft,
//               child: Container(
//                   height: 36.v,
//                   width: 101.h,
//                   margin: EdgeInsets.only(left: 6.h, top: 88.v),
//                   decoration: BoxDecoration(
//                       color: theme.colorScheme.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(10.h),
//                       border: Border.all(
//                           color: theme.colorScheme.primary, width: 1.h)))),
//           Align(
//               alignment: Alignment.center,
//               child: Container(
//                   margin: EdgeInsets.only(left: 4.h, right: 2.h),
//                   padding: EdgeInsets.symmetric(vertical: 15.v),
//                   decoration: BoxDecoration(
//                       image: DecorationImage(
//                           image: fs.Svg(ImageConstant.imgGroup124),
//                           fit: BoxFit.cover)),
//                   child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         CustomOutlinedButton(
//                             height: 36.v,
//                             width: 101.h,
//                             text: "A02",
//                             margin: EdgeInsets.only(right: 1.h),
//                             buttonStyle: CustomButtonStyles.outlinePrimaryTL10,
//                             buttonTextStyle:
//                                 CustomTextStyles.titleMediumBlack900_1,
//                             alignment: Alignment.centerRight),
//                         SizedBox(height: 43.v),
//                         Padding(
//                             padding: EdgeInsets.only(left: 34.h),
//                             child: Text("A03",
//                                 style: CustomTextStyles.titleMediumBlack900_1)),
//                         SizedBox(height: 47.v),
//                         CustomElevatedButton(
//                             height: 36.v,
//                             width: 101.h,
//                             text: "A05",
//                             rightIcon: Container(
//                                 margin: EdgeInsets.only(left: 10.h),
//                                 child: CustomImageView(
//                                     imagePath: ImageConstant.imgCheckmark,
//                                     height: 12.adaptSize,
//                                     width: 12.adaptSize)),
//                             buttonStyle: CustomButtonStyles.fillPrimaryTL10,
//                             buttonTextStyle:
//                                 CustomTextStyles.titleMediumOnPrimary_1),
//                         SizedBox(height: 8.v)
//                       ]))),
//           Align(
//               alignment: Alignment.topCenter,
//               child: Padding(
//                   padding: EdgeInsets.only(top: 66.v),
//                   child: SizedBox(
//                       width: 228.h, child: Divider(color: appTheme.gray500)))),
//           Align(
//               alignment: Alignment.bottomCenter,
//               child: Padding(
//                   padding: EdgeInsets.only(bottom: 78.v),
//                   child: SizedBox(
//                       width: 228.h, child: Divider(color: appTheme.gray500)))),
//           CustomImageView(
//               imagePath: ImageConstant.imgKisspngCarDoo,
//               height: 56.v,
//               width: 107.h,
//               alignment: Alignment.topLeft,
//               margin: EdgeInsets.only(top: 6.v)),
//           CustomImageView(
//               imagePath: ImageConstant.imgKisspngCarDoo56x107,
//               height: 56.v,
//               width: 107.h,
//               alignment: Alignment.topRight,
//               margin: EdgeInsets.only(top: 78.v)),
//           CustomImageView(
//               imagePath: ImageConstant.imgKisspngCarDoo56x107,
//               height: 56.v,
//               width: 107.h,
//               alignment: Alignment.bottomRight,
//               margin: EdgeInsets.only(bottom: 11.v))
//         ]));
//   }

//   /// Section Widget
//   Widget _buildButton(BuildContext context) {
//     return CustomElevatedButton(
//         text: "Continue",
//         margin: EdgeInsets.only(left: 45.h, right: 46.h, bottom: 48.v),
//         onPressed: () {
//           onTapButton(context);
//         });
//   }

//   /// Navigates to the iphone13ProMaxThirtyoneScreen when the action is triggered.
//   onTapImage(BuildContext context) {
//     // Navigator.pushNamed(context, AppRoutes.iphone13ProMaxThir);
//   }

//   /// Navigates to the iphone13ProMaxThirtythreeScreen when the action is triggered.
//   onTapButton(BuildContext context) {
//     // Navigator.pushNamed(context, AppRoutes.iphone13ProMaxThirtythreeScreen);
//   }
// }

// class Chipview2ItemWidget extends StatelessWidget {
//   const Chipview2ItemWidget({Key? key})
//       : super(
//           key: key,
//         );

//   @override
//   Widget build(BuildContext context) {
//     return RawChip(
//       padding: EdgeInsets.symmetric(
//         horizontal: 24.h,
//         vertical: 6.v,
//       ),
//       showCheckmark: false,
//       labelPadding: EdgeInsets.zero,
//       label: Text(
//         "1st Floor",
//         style: TextStyle(
//           color: theme.colorScheme.onPrimary.withOpacity(1),
//           fontSize: 16.fSize,
//           fontFamily: 'Jost',
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//       selected: false,
//       backgroundColor: theme.colorScheme.onPrimary.withOpacity(1),
//       selectedColor: theme.colorScheme.primary,
//       shape: RoundedRectangleBorder(
//         side: BorderSide(
//           color: theme.colorScheme.primary,
//           width: 2.h,
//         ),
//         borderRadius: BorderRadius.circular(
//           18.h,
//         ),
//       ),
//       onSelected: (value) {},
//     );
//   }
// }
>>>>>>> 4a3e920057e177fd2f5d16412818b39ccd897766
