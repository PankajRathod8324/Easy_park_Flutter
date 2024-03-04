import 'package:easy_park_app/common_widget/image_constant.dart';
import 'package:easy_park_app/common_widget/theme/theme_helper.dart';
import 'package:easy_park_app/view/home/book_parking_details.dart';
import 'package:flutter/material.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({Key? key}) : super(key: key);

  @override
  _VehicleScreenState createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  int selectedOption = -1;

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
          "Select Your Vehicle",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOption(context, 0, "4x4 Truck", "HGE 5295",
                ImageConstant.imgKisspngToyota),
            _buildOption(context, 1, "Toyota Land Cruiser", "AFD 6397",
                ImageConstant.img5a3620812343531),
            _buildOption(context, 2, "KIA SELTOS", "HUC 2957",
                ImageConstant.imgKisspngCarCli),
            _buildOption(context, 3, "Honda City", "GTK 6294",
                ImageConstant.imgKisspng2017Te),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (selectedOption != -1) {
                  // Handle continue button click with the selected option
                  print("Selected option: $selectedOption");

                  // Navigate to the Book Parking Details page
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => BookParkingPage(),
                    ),
                  );
                } else {
                  // Show a message or handle the case where no option is selected
                }
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(BuildContext context, int index, String name,
      String plate, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedOption = index;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: selectedOption == index
              ? Color.fromARGB(255, 216, 28, 132).withOpacity(0.2)
              : Colors.transparent,
          border: Border.all(color: theme.colorScheme.primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Image.asset(
              imagePath,
              height: 80,
              width: 80,
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(plate),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// class BookParkingDetailsScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Book Parking Details"),
//       ),
//       body: Center(
//         child: Text("This is the Book Parking Details screen"),
//       ),
//     );
//   }
// }

void main() {
  runApp(MaterialApp(
    home: VehicleScreen(),
  ));
}




// import 'package:easy_park_app/common_widget/custom_image_view.dart';
// import 'package:easy_park_app/common_widget/image_constant.dart';
// import 'package:easy_park_app/common_widget/theme/app_decoration.dart';
// import 'package:easy_park_app/common_widget/theme/custom_button_style.dart';
// import 'package:easy_park_app/common_widget/theme/custom_text_style.dart';
// import 'package:easy_park_app/common_widget/theme/theme_helper.dart';
// import 'package:easy_park_app/common_widget/utils/size_utils.dart';
// import 'package:easy_park_app/common_widget/widgets/app_bar/appbar_leading_image.dart';
// import 'package:easy_park_app/common_widget/widgets/app_bar/appbar_subtitle.dart';
// import 'package:easy_park_app/common_widget/widgets/app_bar/custom_app_bar.dart';
// import 'package:easy_park_app/common_widget/widgets/custom_elevated_button.dart';
// import 'package:easy_park_app/view/home/book_parking_details.dart';
// import 'package:flutter/material.dart';

// class VehicleScreen extends StatelessWidget {
//   const VehicleScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);

//     // Initialize SizeUtils based on context
//     // SizeUtils.initialize(context);

//     return SafeArea(
//       child: Scaffold(
//         appBar: _buildAppBar(context),
//         body: Container(
//           width: double.maxFinite,
//           padding: EdgeInsets.symmetric(horizontal: 27.h, vertical: 21.v),
//           child: Column(
//             children: [
//               _buildThirtyThree(context, theme),
//               SizedBox(height: 22.v),
//               _buildFortyOne(context, theme),
//               SizedBox(height: 22.v),
//               _buildThirtyNine(context, theme),
//               SizedBox(height: 22.v),
//               _buildThirtyEight(context, theme),
//               SizedBox(height: 32.v),
//               CustomElevatedButton(
//                 text: "Add New Vehicle",
//                 buttonStyle: CustomButtonStyles.fillPrimaryTL26,
//                 buttonTextStyle: CustomTextStyles.titleMediumMontserratPrimary,
//               ),
//               SizedBox(height: 5.v),
//             ],
//           ),
//         ),
//         bottomNavigationBar: _buildContinue(context),
//       ),
//     );
//   }

//   PreferredSizeWidget _buildAppBar(BuildContext context) {
//     return CustomAppBar(
//       leadingWidth: 59.h,
//       leading: AppbarLeadingImage(
//         imagePath: ImageConstant.imgFrameOnprimarycontainer,
//         margin: EdgeInsets.only(left: 33.h, top: 20.v, bottom: 17.v),
//         onTap: () {
//           onTapImage(context);
//         },
//       ),
//       centerTitle: true,
//       title: AppbarSubtitle(text: "Select Your Vehicle"),
//     );
//   }

//   Widget _buildThirtyThree(BuildContext context, ThemeData theme) {
//     return Container(
//       margin: EdgeInsets.only(right: 1.h),
//       padding: EdgeInsets.symmetric(horizontal: 9.h),
//       decoration: AppDecoration.fillGray100.copyWith(
//         borderRadius: BorderRadiusStyle.circleBorder24,
//       ),
//       child: Row(
//         children: [
//           CustomImageView(
//             imagePath: ImageConstant.img5a3620812343531,
//             height: 86.v,
//             width: 104.h,
//             margin: EdgeInsets.only(bottom: 7.v),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 26.h, top: 25.v, bottom: 25.v),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("4x4 Truck", style: theme.textTheme.titleMedium),
//                 Text("HGE 5295", style: CustomTextStyles.labelLargeBluegray900),
//               ],
//             ),
//           ),
//           Spacer(),
//           Container(
//             height: 17.adaptSize,
//             width: 17.adaptSize,
//             margin: EdgeInsets.only(top: 38.v, right: 24.h, bottom: 38.v),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.h),
//               border: Border.all(color: theme.colorScheme.primary, width: 2.h),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFortyOne(BuildContext context, ThemeData theme) {
//     return Container(
//       margin: EdgeInsets.only(right: 1.h),
//       padding: EdgeInsets.all(12.h),
//       decoration: AppDecoration.outlinePrimary3.copyWith(
//         borderRadius: BorderRadiusStyle.circleBorder24,
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomImageView(
//                   imagePath: ImageConstant.imgKisspngToyota,
//                   height: 65.v,
//                   width: 107.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 13.v, bottom: 11.v),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Toyota  Land Cruiser",
//                         style: theme.textTheme.titleMedium,
//                       ),
//                       Text(
//                         "AFD 6397",
//                         style: CustomTextStyles.labelLargeBluegray900,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             margin: EdgeInsets.only(left: 37.h, top: 24.v, bottom: 24.v),
//             padding: EdgeInsets.all(1.h),
//             decoration: AppDecoration.outlinePrimary4.copyWith(
//               borderRadius: BorderRadiusStyle.roundedBorder8,
//             ),
//             child: Container(
//               height: 12.adaptSize,
//               width: 12.adaptSize,
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.primary,
//                 borderRadius: BorderRadius.circular(6.h),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildThirtyNine(BuildContext context, ThemeData theme) {
//     return Container(
//       margin: EdgeInsets.only(right: 1.h),
//       padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 16.v),
//       decoration: AppDecoration.fillGray100.copyWith(
//         borderRadius: BorderRadiusStyle.circleBorder24,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 213.h,
//             margin: EdgeInsets.only(bottom: 8.v),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomImageView(
//                   imagePath: ImageConstant.imgKisspngCarCli,
//                   height: 53.v,
//                   width: 111.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 10.v),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "KIA SELTOS",
//                         style: theme.textTheme.titleMedium,
//                       ),
//                       Text(
//                         "HUC 2957",
//                         style: CustomTextStyles.labelLargeBluegray900,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 17.adaptSize,
//             width: 17.adaptSize,
//             margin: EdgeInsets.only(top: 22.v, right: 19.h, bottom: 22.v),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.h),
//               border: Border.all(color: theme.colorScheme.primary, width: 2.h),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildThirtyEight(BuildContext context, ThemeData theme) {
//     return Container(
//       margin: EdgeInsets.only(right: 1.h),
//       padding: EdgeInsets.symmetric(horizontal: 8.h, vertical: 21.v),
//       decoration: AppDecoration.fillGray100.copyWith(
//         borderRadius: BorderRadiusStyle.circleBorder24,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 214.h,
//             margin: EdgeInsets.only(bottom: 4.v),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 CustomImageView(
//                   imagePath: ImageConstant.imgKisspng2017Te,
//                   height: 46.v,
//                   width: 116.h,
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(top: 6.v),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Honda City",
//                         style: theme.textTheme.titleMedium,
//                       ),
//                       Text(
//                         "GTK 6294",
//                         style: CustomTextStyles.labelLargeBluegray900,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             height: 17.adaptSize,
//             width: 17.adaptSize,
//             margin: EdgeInsets.only(top: 17.v, right: 25.h, bottom: 17.v),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8.h),
//               border: Border.all(color: theme.colorScheme.primary, width: 2.h),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildContinue(BuildContext context) {
//     return CustomElevatedButton(
//       text: "Continue",
//       margin: EdgeInsets.only(left: 45.h, right: 46.h, bottom: 48.v),
//       onPressed: () {
//         onTapContinue(context);
//       },
//     );
//   }

//   void onTapImage(BuildContext context) {
//     Navigator.of(context).pop();
//   }

//   void onTapContinue(BuildContext context) {
//     Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => BookParkingDetailsScreen()));
//   }
// }
// // class SizeUtils {
// //   static double screenWidth = 0.0;
// //   static double screenHeight = 0.0;

// //   static void initialize(BuildContext context) {
// //     screenWidth = MediaQuery.of(context).size.width;
// //     screenHeight = MediaQuery.of(context).size.height;
// //   }

// //   // Add other utility methods if needed
// // }