import 'package:easy_park_app/common_widget/custom_image_view.dart';
import 'package:easy_park_app/common_widget/image_constant.dart';
import 'package:easy_park_app/common_widget/theme/custom_button_style.dart';
import 'package:easy_park_app/common_widget/theme/custom_text_style.dart';
import 'package:easy_park_app/common_widget/theme/theme_helper.dart';
import 'package:easy_park_app/common_widget/utils/size_utils.dart';
import 'package:easy_park_app/common_widget/widgets/custom_elevated_button.dart';
import 'package:easy_park_app/view/login/choose_owner_user.dart';
import 'package:easy_park_app/view/login/splash_view_6.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashView5Screen extends StatelessWidget {
  const SplashView5Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: 6.h),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImageView(
                          imagePath: ImageConstant.imgUndrawOnlineP,
                          height: 299.v,
                          width: 391.h,
                          alignment: Alignment.centerLeft),
                      SizedBox(height: 52.v),
                      Container(
                          width: 307.h,
                          margin: EdgeInsets.only(left: 52.h, right: 56.h),
                          child: Text(
                              "Book and Pay Parking\r\nQuickly & Safely",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: CustomTextStyles.headlineLargeBlack90031)),
                      SizedBox(height: 1.v),
                      SizedBox(height: 48.v),
                      SizedBox(
                          height: 5.v,
                          child: AnimatedSmoothIndicator(
                              activeIndex: 1,
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
                          margin: EdgeInsets.only(left: 40.h, right: 40.h),
                          buttonStyle: CustomButtonStyles.fillBlueGray,
                          buttonTextStyle:
                              CustomTextStyles.titleMediumMontserratPrimary,
                          onPressed: () {
                            onTapNext(context);
                          }),
                      SizedBox(height: 11.v),
                      CustomElevatedButton(
                          text: "Skip",
                          margin: EdgeInsets.only(left: 39.h, right: 40.h),
                          buttonStyle: CustomButtonStyles.fillBlueGray,
                          buttonTextStyle:
                              CustomTextStyles.titleMediumMontserratPrimary,
                          onPressed: () {
                            onTapSkip(context);
                          }),
                      SizedBox(height: 5.v)
                    ]))));
  }

  /// Navigates to the iphone13ProMaxSixScreen when the action is triggered.
  onTapNext(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SplashView6Screen()));
  }

  /// Navigates to the iphone13ProMaxSevenScreen when the action is triggered.
  onTapSkip(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChooseOwnerUser()));
  }
}
