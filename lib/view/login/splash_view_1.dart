import 'package:easy_park_app/common_widget/custom_image_view.dart';
import 'package:easy_park_app/common_widget/image_constant.dart';
import 'package:easy_park_app/common_widget/utils/size_utils.dart';
import 'package:easy_park_app/view/login/splash_view.dart';
import 'package:flutter/material.dart';

class SplashView1 extends StatelessWidget {
  const SplashView1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Using Future.delayed to navigate to the second screen after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SplashView(),
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
        body: SizedBox(
          width: double.maxFinite,
          child: CustomImageView(
            imagePath: ImageConstant.imgImage1,
            height: 926.v,
            width: 428.h,
            alignment: Alignment.center,
          ),
        ),
      ),
    );
  }
}
