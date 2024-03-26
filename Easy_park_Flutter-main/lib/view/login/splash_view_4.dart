import 'package:easy_park_app/common_widget/custom_image_view.dart';
import 'package:easy_park_app/common_widget/image_constant.dart';
import 'package:easy_park_app/common_widget/theme/custom_button_style.dart';
import 'package:easy_park_app/common_widget/theme/custom_text_style.dart';
import 'package:easy_park_app/common_widget/theme/theme_helper.dart';
import 'package:easy_park_app/common_widget/utils/size_utils.dart';
import 'package:easy_park_app/common_widget/widgets/custom_elevated_button.dart';
import 'package:easy_park_app/view/login/choose_owner_user.dart';
import 'package:easy_park_app/view/login/splash_view_5.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SplashView4Screen extends StatelessWidget {
  const SplashView4Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeUtils.setScreenSize(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      MediaQuery.of(context).orientation,
    );
    return SafeArea(
        child: Scaffold(
            body: Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(vertical: 19.v),
                child: Column(children: [
                  CustomImageView(
                      imagePath: ImageConstant.imgUndrawTouristMapRe293e,
                      height: 369.v,
                      width: 428.h),
                  SizedBox(height: 28.v),
                  SizedBox(
                      width: 284.h,
                      child: Text("Find Parking Places \r\nAround You Easily",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: CustomTextStyles.headlineLargeBlack900)),
                  SizedBox(height: 48.v),
                  SizedBox(
                      height: 5.v,
                      child: AnimatedSmoothIndicator(
                          activeIndex: 0,
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
                      margin: EdgeInsets.only(left: 45.h, right: 45.h),
                      buttonStyle: CustomButtonStyles.fillBlueGray,
                      buttonTextStyle:
                          CustomTextStyles.titleMediumMontserratPrimary,
                      onPressed: () {
                        onTapNext(context);
                      }),
                  SizedBox(height: 11.v),
                  CustomElevatedButton(
                      text: "Skip",
                      margin: EdgeInsets.only(left: 45.h, right: 46.h),
                      buttonStyle: CustomButtonStyles.fillBlueGray,
                      buttonTextStyle:
                          CustomTextStyles.titleMediumMontserratPrimary,
                      onPressed: () {
                        onTapSkip(context);
                      }),
                  SizedBox(height: 5.v)
                ]))));
  }

  /// Navigates to the iphone13ProMaxFiveScreen when the action is triggered.
  onTapNext(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => SplashView5Screen()));
  }

  /// Navigates to the iphone13ProMaxSevenScreen when the action is triggered.
  onTapSkip(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => ChooseOwnerUser()));
  }
}
