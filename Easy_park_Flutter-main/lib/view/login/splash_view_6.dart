import 'package:easy_park_app/common_widget/widgets/custom_elevated_button.dart';
import 'package:easy_park_app/view/login/choose_owner_user.dart';
import 'package:easy_park_app/view/login/welcome_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_park_app/common_widget/app_export.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashView6Screen extends StatelessWidget {
  const SplashView6Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                          imagePath: ImageConstant.imgUndrawSeasonChangeF99v,
                          height: 288.v,
                          width: 382.h),
                      SizedBox(height: 50.v),
                      Container(
                          width: 288.h,
                          margin: EdgeInsets.only(left: 45.h, right: 53.h),
                          child: Text("Extend Parking Time\r\nAs You Need",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: CustomTextStyles.headlineLargeBlack90031)),
                      SizedBox(height: 3.v),
                      SizedBox(height: 48.v),
                      SizedBox(
                          height: 5.v,
                          child: AnimatedSmoothIndicator(
                              activeIndex: 2,
                              count: 3,
                              effect: ScrollingDotsEffect(
                                  spacing: 3,
                                  activeDotColor: theme.colorScheme.primary,
                                  dotColor: appTheme.blueGray10001,
                                  dotHeight: 5.v,
                                  dotWidth: 20.h))),
                      SizedBox(height: 50.v),
                      CustomElevatedButton(
                          text: "Next",
                          margin: EdgeInsets.only(left: 25.h, right: 26.h),
                          buttonStyle: CustomButtonStyles.fillBlueGray,
                          buttonTextStyle:
                              CustomTextStyles.titleMediumMontserratPrimary,
                          onPressed: () {
                            onTapNext(context);
                          }),
                      SizedBox(height: 11.v),
                      CustomElevatedButton(
                          text: "Skip",
                          margin: EdgeInsets.only(left: 25.h, right: 26.h),
                          buttonStyle: CustomButtonStyles.fillBlueGray,
                          buttonTextStyle:
                              CustomTextStyles.titleMediumMontserratPrimary,
                          onPressed: () {
                            onTapSkip(context);
                          }),
                      SizedBox(height: 4.v)
                    ]))));
  }

  /// Navigates to the iphone13ProMaxSevenScreen when the action is triggered.
  onTapNext(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChooseOwnerUser()));
  }

  /// Navigates to the iphone13ProMaxSevenScreen when the action is triggered.
  onTapSkip(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChooseOwnerUser()));
  }
}
