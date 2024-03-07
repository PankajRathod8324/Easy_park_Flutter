// import 'package:flutter/material.dart';

import 'package:easy_park_app/common_widget/custom_image_view.dart';
import 'package:easy_park_app/common_widget/image_constant.dart';
import 'package:easy_park_app/common_widget/theme/theme_helper.dart';
import 'package:easy_park_app/common_widget/utils/size_utils.dart';
import 'package:easy_park_app/view/login/splash_view_4.dart';
import 'package:flutter/material.dart';

class SplashView3Screen extends StatelessWidget {
  const SplashView3Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using Future.delayed to navigate to the fourth screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashView4Screen(),
        ),
      );
    });

    SizeUtils.setScreenSize(
      BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
        maxHeight: MediaQuery.of(context).size.height,
      ),
      MediaQuery.of(context).orientation,
    );
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: Container(
          width: SizeUtils.width,
          height: SizeUtils.height,
          decoration: BoxDecoration(
            color: theme.colorScheme.onPrimary.withOpacity(1),
            image: DecorationImage(
              image: AssetImage(
                ImageConstant.imgIphone13ProMax,
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: 20.h,
              vertical: 71.v,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(),
                SizedBox(
                  height: 126.v,
                  width: 288.h,
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstant.imgImage5,
                        height: 101.v,
                        width: 288.h,
                        alignment: Alignment.topCenter,
                      ),
                      CustomImageView(
                        imagePath: ImageConstant.imgImage6,
                        height: 51.v,
                        width: 206.h,
                        alignment: Alignment.bottomLeft,
                        margin: EdgeInsets.only(left: 11.h),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 13.v),
                CustomImageView(
                  imagePath: ImageConstant.imgImage7,
                  height: 45.v,
                  width: 373.h,
                  margin: EdgeInsets.only(left: 14.h),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
