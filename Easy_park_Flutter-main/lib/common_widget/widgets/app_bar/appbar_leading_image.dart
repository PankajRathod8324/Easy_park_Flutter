import 'package:easy_park_app/common_widget/custom_image_view.dart';
import 'package:easy_park_app/common_widget/utils/size_utils.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class AppbarLeadingImage extends StatelessWidget {
  AppbarLeadingImage({
    Key? key,
    this.imagePath,
    this.margin,
    this.onTap,
  }) : super(
          key: key,
        );

  String? imagePath;

  EdgeInsetsGeometry? margin;

  Function? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap!.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomImageView(
          imagePath: imagePath,
          height: 18.v,
          width: 26.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
