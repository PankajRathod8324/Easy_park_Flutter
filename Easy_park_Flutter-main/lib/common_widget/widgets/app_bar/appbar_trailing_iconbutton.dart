import 'package:easy_park_app/common_widget/custom_image_view.dart';
import 'package:easy_park_app/common_widget/image_constant.dart';
import 'package:easy_park_app/common_widget/utils/size_utils.dart';
import 'package:easy_park_app/common_widget/widgets/custom_icon_button.dart';
import 'package:flutter/material.dart';


// ignore: must_be_immutable
class AppbarTrailingIconbutton extends StatelessWidget {
  AppbarTrailingIconbutton({
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
    return GestureDetector(
      onTap: () {
        onTap!.call();
      },
      child: Padding(
        padding: margin ?? EdgeInsets.zero,
        child: CustomIconButton(
          height: 28.adaptSize,
          width: 28.adaptSize,
          decoration: IconButtonStyleHelper.outlineBlack,
          child: CustomImageView(
            imagePath: ImageConstant.imgGroup86,
          ),
        ),
      ),
    );
  }
}
