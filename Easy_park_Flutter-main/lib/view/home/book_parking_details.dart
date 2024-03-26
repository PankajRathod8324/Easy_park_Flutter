import 'package:easy_park_app/view/home/payment.dart';
import 'package:easy_park_app/view/home/pick_spot.dart';
import 'package:easy_park_app/view/menu/payment_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: BookParkingPage(),
  ));
}

class BookParkingPage extends StatefulWidget {
  const BookParkingPage({Key? key}) : super(key: key);

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

            // Section 2: Distance Panel
            Text("Select Duration (Hours)"),
            _buildDistanceBar(),

            // Section 3: Start and End Hour
            Text("Start Hour"),
            _buildHourButton("Start Hour", selectedStartTime, () {
              _selectTime(context, selectedStartTime, (time) {
                setState(() {
                  selectedStartTime = time;
                  startHour = time.hour + time.minute / 60.0;
                });
              });
            }),

            Text("End Hour"),
            _buildHourButton("End Hour", selectedEndTime, () {
              _selectTime(context, selectedEndTime, (time) {
                setState(() {
                  selectedEndTime = time;
                  endHour = time.hour + time.minute / 60.0;
                });
              });
            }),

            // Section 4: Total Price
            Text("Total Price"),
            _buildTotalPrice(),

            // Section 5: Continue Button
            ElevatedButton(
              onPressed: () {
                // Handle continue button press
                // Calculate total cost or navigate to the next page
                print("Continue button pressed");
                _calculateTotalCost();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                      // selectedDate: selectedDate,
                      // selectedStartTime: selectedStartTime,
                      // selectedEndTime: selectedEndTime,
                      // selectedDuration: selectedDuration,
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
    // Assuming $8 per hour
    double totalPrice = (endHour - startHour) * selectedDuration * 8.0;
    return Text("\$$totalPrice");
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2022),
          lastDate: DateTime(2030),
        )) ??
        DateTime.now();

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TimeOfDay initialTime, ValueChanged<TimeOfDay> onChanged) async {
    final TimeOfDay picked = (await showTimePicker(
          context: context,
          initialTime: initialTime,
        )) ??
        TimeOfDay.now();

    if (picked != null && picked != initialTime) {
      onChanged(picked);
    }
  }

  void _calculateTotalCost() {
    // Calculate and display the total cost based on the selected hours and duration
    double totalPrice = (endHour - startHour) * selectedDuration * 8.0;
    print("Total Price: \$$totalPrice");
  }
}


// import 'package:easy_park_app/common_widget/custom_image_view.dart';
// import 'package:easy_park_app/common_widget/image_constant.dart';
// import 'package:easy_park_app/common_widget/theme/app_decoration.dart';
// import 'package:easy_park_app/common_widget/theme/custom_text_style.dart';
// import 'package:easy_park_app/common_widget/theme/theme_helper.dart';
// import 'package:easy_park_app/common_widget/utils/size_utils.dart';
// import 'package:easy_park_app/common_widget/widgets/app_bar/appbar_leading_image.dart';
// import 'package:easy_park_app/common_widget/widgets/app_bar/appbar_subtitle.dart';
// import 'package:easy_park_app/common_widget/widgets/app_bar/custom_app_bar.dart';
// import 'package:easy_park_app/common_widget/widgets/custom_elevated_button.dart';
// import 'package:flutter/material.dart';

// class BookParkingDetailsScreen extends StatelessWidget {
//   const BookParkingDetailsScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//         child: Scaffold(
//             appBar: _buildAppBar(context),
//             body: Container(
//                 width: double.maxFinite,
//                 padding: EdgeInsets.symmetric(horizontal: 1.h, vertical: 13.v),
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Padding(
//                           padding: EdgeInsets.only(left: 35.h),
//                           child: Text("Select Date",
//                               style: CustomTextStyles.titleMediumBlack900)),
//                       SizedBox(height: 20.v),
//                       _buildSeventyOne(context),
//                       SizedBox(height: 31.v),
//                       _buildVector(context),
//                       SizedBox(height: 31.v),
//                       Padding(
//                           padding: EdgeInsets.only(left: 29.h, right: 92.h),
//                           child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Text("Start Hour",
//                                     style: theme.textTheme.titleLarge),
//                                 Text("End Hour",
//                                     style: theme.textTheme.titleLarge)
//                               ])),
//                       SizedBox(height: 16.v),
//                       _buildTime(context),
//                       SizedBox(height: 15.v),
//                       Padding(
//                           padding: EdgeInsets.only(left: 31.h),
//                           child:
//                               Text("Total", style: theme.textTheme.titleLarge)),
//                       SizedBox(height: 3.v),
//                       Padding(
//                           padding: EdgeInsets.only(left: 31.h),
//                           child: Row(children: [
//                             Text("8.00 ",
//                                 style: CustomTextStyles.headlineSmallPrimary),
//                             Padding(
//                                 padding:
//                                     EdgeInsets.only(top: 11.v, bottom: 2.v),
//                                 child: Text("/4 hours",
//                                     style:
//                                         CustomTextStyles.titleSmallGray50014))
//                           ])),
//                       SizedBox(height: 5.v)
//                     ])),
//             bottomNavigationBar: _buildContinue(context)));
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
//         centerTitle: true,
//         title: AppbarSubtitle(text: "Book Parking Details"));
//   }

//   /// Section Widget
//   Widget _buildSeventyOne(BuildContext context) {
//     return SizedBox(
//         height: 292.v,
//         width: 402.h,
//         child: Stack(alignment: Alignment.topLeft, children: [
//           Align(
//               alignment: Alignment.centerRight,
//               child: Container(
//                   margin: EdgeInsets.only(left: 23.h),
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 23.h, vertical: 12.v),
//                   decoration: AppDecoration.fillGray10002
//                       .copyWith(borderRadius: BorderRadiusStyle.circleBorder21),
//                   child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                             padding: EdgeInsets.only(left: 3.h),
//                             child: Text("May 2023",
//                                 style: theme.textTheme.titleLarge)),
//                         SizedBox(height: 50.v),
//                         Padding(
//                             padding: EdgeInsets.only(left: 7.h, right: 4.h),
//                             child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text("25", style: theme.textTheme.bodySmall),
//                                   Text("26", style: theme.textTheme.bodySmall),
//                                   Text("27", style: theme.textTheme.bodySmall),
//                                   Text("28", style: theme.textTheme.bodySmall),
//                                   Text("29", style: theme.textTheme.bodySmall),
//                                   Text("30", style: theme.textTheme.bodySmall),
//                                   Text("1", style: theme.textTheme.bodySmall)
//                                 ])),
//                         SizedBox(height: 25.v),
//                         Padding(
//                             padding: EdgeInsets.only(left: 7.h),
//                             child: _buildEightyThree(context,
//                                 text: "2",
//                                 text1: "3",
//                                 text2: "4",
//                                 text3: "5",
//                                 text4: "6",
//                                 text5: "7",
//                                 text6: "8")),
//                         SizedBox(height: 15.v),
//                         Container(
//                             height: 32.v,
//                             width: 324.h,
//                             margin: EdgeInsets.only(left: 7.h),
//                             child: Stack(
//                                 alignment: Alignment.topCenter,
//                                 children: [
//                                   Align(
//                                       alignment: Alignment.centerLeft,
//                                       child: Container(
//                                           height: 32.adaptSize,
//                                           width: 32.adaptSize,
//                                           margin: EdgeInsets.only(left: 93.h),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(16.h),
//                                               gradient: LinearGradient(
//                                                   begin:
//                                                       Alignment(-0.42, -1.22),
//                                                   end: Alignment(0.5, 1),
//                                                   colors: [
//                                                     theme.colorScheme.primary
//                                                         .withOpacity(0),
//                                                     theme.colorScheme.primary
//                                                   ])))),
//                                   Align(
//                                       alignment: Alignment.topCenter,
//                                       child: Padding(
//                                           padding: EdgeInsets.symmetric(
//                                               vertical: 8.v),
//                                           child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Text("9",
//                                                     style: theme
//                                                         .textTheme.bodySmall),
//                                                 Text("10",
//                                                     style: theme
//                                                         .textTheme.bodySmall),
//                                                 Text("11",
//                                                     style: CustomTextStyles
//                                                         .bodySmallOnPrimary_1),
//                                                 Text("12",
//                                                     style: theme
//                                                         .textTheme.bodySmall),
//                                                 Text("13",
//                                                     style: theme
//                                                         .textTheme.bodySmall),
//                                                 Text("14",
//                                                     style: theme
//                                                         .textTheme.bodySmall),
//                                                 Text("15",
//                                                     style: theme
//                                                         .textTheme.bodySmall)
//                                               ])))
//                                 ])),
//                         SizedBox(height: 14.v),
//                         Padding(
//                             padding: EdgeInsets.only(left: 7.h),
//                             child: _buildEightyThree(context,
//                                 text: "16",
//                                 text1: "17",
//                                 text2: "18",
//                                 text3: "19",
//                                 text4: "20",
//                                 text5: "21",
//                                 text6: "22")),
//                         SizedBox(height: 22.v),
//                         Padding(
//                             padding: EdgeInsets.only(left: 7.h),
//                             child: Row(children: [
//                               Text("31", style: theme.textTheme.bodySmall),
//                               Padding(
//                                   padding: EdgeInsets.only(left: 38.h),
//                                   child: Text("30",
//                                       style: theme.textTheme.bodySmall))
//                             ])),
//                         SizedBox(height: 22.v)
//                       ]))),
//           Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                   padding:
//                       EdgeInsets.only(top: 50.v, right: 22.h, bottom: 227.v),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("05", style: CustomTextStyles.bodySmallOnPrimary),
//                         Text("Mo",
//                             style: CustomTextStyles.labelMediumInterBlack900),
//                         Text("Tu",
//                             style: CustomTextStyles.labelMediumInterBlack900),
//                         Text("We",
//                             style: CustomTextStyles.labelMediumInterBlack900),
//                         Text("Th",
//                             style: CustomTextStyles.labelMediumInterBlack900),
//                         Text("Fr",
//                             style: CustomTextStyles.labelMediumInterBlack900),
//                         Text("Sa",
//                             style: CustomTextStyles.labelMediumInterBlack900),
//                         Text("Su",
//                             style: CustomTextStyles.labelMediumInterBlack900)
//                       ])))
//         ]));
//   }

//   /// Section Widget
//   Widget _buildDistance(BuildContext context) {
//     return Align(
//         alignment: Alignment.centerLeft,
//         child: Padding(
//             padding: EdgeInsets.only(right: 203.h),
//             child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Distance", style: theme.textTheme.titleLarge),
//                   SizedBox(height: 8.v),
//                   Align(
//                       alignment: Alignment.centerRight,
//                       child: SizedBox(
//                           height: 20.v,
//                           width: 34.h,
//                           child:
//                               Stack(alignment: Alignment.topRight, children: [
//                             CustomImageView(
//                                 imagePath: ImageConstant.imgVector20x34,
//                                 height: 20.v,
//                                 width: 34.h,
//                                 alignment: Alignment.center),
//                             Align(
//                                 alignment: Alignment.topRight,
//                                 child: Padding(
//                                     padding:
//                                         EdgeInsets.only(top: 1.v, right: 5.h),
//                                     child: Text(" 4 hrs",
//                                         style: CustomTextStyles
//                                             .labelSmallJostOnPrimary)))
//                           ]))),
//                   SizedBox(height: 9.v),
//                   SizedBox(
//                       height: 16.v,
//                       width: 156.h,
//                       child: Stack(alignment: Alignment.centerRight, children: [
//                         CustomImageView(
//                             imagePath: ImageConstant.imgVector7x154,
//                             height: 7.v,
//                             width: 154.h,
//                             alignment: Alignment.bottomCenter,
//                             margin: EdgeInsets.only(bottom: 3.v)),
//                         CustomImageView(
//                             imagePath: ImageConstant.imgGroup,
//                             height: 16.adaptSize,
//                             width: 16.adaptSize,
//                             alignment: Alignment.centerRight)
//                       ]))
//                 ])));
//   }

//   /// Section Widget
//   Widget _buildVector(BuildContext context) {
//     return Align(
//         alignment: Alignment.center,
//         child: SizedBox(
//             height: 83.v,
//             width: 368.h,
//             child: Stack(alignment: Alignment.centerLeft, children: [
//               CustomImageView(
//                   imagePath: ImageConstant.imgVectorBlueGray100,
//                   height: 7.v,
//                   width: 216.h,
//                   alignment: Alignment.bottomRight,
//                   margin: EdgeInsets.only(bottom: 3.v)),
//               _buildDistance(context)
//             ])));
//   }

//   /// Section Widget
//   Widget _buildTime(BuildContext context) {
//     return Align(
//         alignment: Alignment.center,
//         child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 28.h),
//             child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildSeventyFive(context, time: "09:00"),
//                   _buildSeventyFive(context, time: "13:00")
//                 ])));
//   }

//   /// Section Widget
//   Widget _buildContinue(BuildContext context) {
//     return CustomElevatedButton(
//         text: "Continue",
//         margin: EdgeInsets.only(left: 45.h, right: 46.h, bottom: 48.v),
//         onPressed: () {
//           onTapContinue(context);
//         });
//   }

//   /// Common widget
//   Widget _buildEightyThree(
//     BuildContext context, {
//     required String text,
//     required String text1,
//     required String text2,
//     required String text3,
//     required String text4,
//     required String text5,
//     required String text6,
//   }) {
//     return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       Text(text,
//           style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900)),
//       Text(text1,
//           style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900)),
//       Text(text2,
//           style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900)),
//       Text(text3,
//           style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900)),
//       Text(text4,
//           style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900)),
//       Text(text5,
//           style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900)),
//       Text(text6,
//           style: theme.textTheme.bodySmall!.copyWith(color: appTheme.black900))
//     ]);
//   }

//   /// Common widget
//   Widget _buildSeventyFive(
//     BuildContext context, {
//     required String time,
//   }) {
//     return Container(
//         padding: EdgeInsets.symmetric(horizontal: 18.h, vertical: 9.v),
//         decoration: AppDecoration.fillGray
//             .copyWith(borderRadius: BorderRadiusStyle.roundedBorder8),
//         child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
//           Text(time,
//               style: CustomTextStyles.titleLargeMedium
//                   .copyWith(color: appTheme.black900)),
//           CustomImageView(
//               imagePath: ImageConstant.imgClock,
//               height: 17.adaptSize,
//               width: 17.adaptSize,
//               margin: EdgeInsets.only(left: 28.h, top: 6.v, bottom: 6.v))
//         ]));
//   }

//   /// Navigates to the iphone13ProMaxThirtyScreen when the action is triggered.
//   onTapImage(BuildContext context) {
//     Navigator.of(context).pop();
//   }

//   /// Navigates to the iphone13ProMaxThirtytwoScreen when the action is triggered.
//   onTapContinue(BuildContext context) {
//     // Navigator.pushNamed(context, AppRoutes.iphone13ProMaxThirtytwoScreen);
//   }
// }
