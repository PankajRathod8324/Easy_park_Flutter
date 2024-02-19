import 'package:easy_park_app/common_widget/utils/size_utils.dart';
import 'package:easy_park_app/view/menu/menu_view.dart';
import 'package:flutter/material.dart';
import 'package:easy_park_app/common_widget/chipview_item_widget.dart';
import 'package:easy_park_app/common_widget/custom_image_view.dart';
import 'package:easy_park_app/common_widget/image_constant.dart';
import 'package:easy_park_app/common_widget/theme/custom_text_style.dart';
import 'package:easy_park_app/common_widget/theme/theme_helper.dart';
import 'package:easy_park_app/common_widget/widgets/app_bar/appbar_leading_image.dart';
import 'package:easy_park_app/common_widget/widgets/app_bar/appbar_subtitle.dart';
import 'package:easy_park_app/common_widget/widgets/app_bar/custom_app_bar.dart';
import 'package:easy_park_app/view/home/half_details.dart';

class FullDetailsScreen extends StatelessWidget {
  FullDetailsScreen({super.key});
  final ThemeData theme = ThemeData();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(horizontal: 26.h, vertical: 14.v),
          child: Column(
            children: [
              // Image Container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage("assets/img/deatils.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 176.v,
                width: 368.h,
              ),
              SizedBox(height: 28.v),
              // Parking Lot Details
              Padding(
                padding: EdgeInsets.only(left: 23.h, right: 28.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Parking Lot of San Manolia",
                            style: theme.textTheme.titleLarge,
                          ),
                          Text(
                            "9569, Trantow Courts, San Manolia",
                            style: CustomTextStyles.titleSmallGray500Medium,
                          ),
                        ],
                      ),
                    ),
                    CustomImageView(
                      imagePath: ImageConstant.imgBookmarkPrimary,
                      height: 31.v, // <-- Add the height value here
                      width: 21.h,
                      margin:
                          EdgeInsets.only(left: 60.h, top: 9.v, bottom: 9.v),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 37.v),
              _buildChipView(context),
              SizedBox(height: 36.v),
              // Description Section
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 4.h),
                  child: Text(
                    "Description",
                    style: theme.textTheme.titleLarge,
                  ),
                ),
              ),
              SizedBox(height: 2.v),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 353.h,
                  child: CustomReadMoreText(
                    text:
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining ",
                    trimLines: 7,
                    colorClickableText: theme.colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(height: 13.v),
              // Additional Widgets (e.g., _buildFortyTwo, _buildCancel) go here
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
      leadingWidth: 59.h,
      leading: AppbarLeadingImage(
        imagePath: ImageConstant.imgFrameOnprimarycontainer,
        margin: EdgeInsets.only(left: 33.h, top: 17.v, bottom: 20.v),
        onTap: () {
          onTapImage(context);
        },
      ),
      title: AppbarSubtitle(
        text: "Parking Details",
        margin: EdgeInsets.only(left: 19.h),
      ),
    );
  }

  Widget _buildChipView(BuildContext context) {
    return Wrap(
      runSpacing: 9.v,
      spacing: 9.h,
      children: List<Widget>.generate(3, (index) => ChipviewItemWidget()),
    );
  }

  onTapImage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => HalfDetailsView(),
      isScrollControlled: true,
    );
  }

  onTapCancel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => HalfDetailsView(),
      isScrollControlled: true,
    );
  }

  onTapBookParking(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => MenuView()));
  }
}

class CustomReadMoreText extends StatefulWidget {
  final String text;
  final int trimLines;
  final Color colorClickableText;

  CustomReadMoreText({
    required this.text,
    required this.trimLines,
    required this.colorClickableText,
  });

  @override
  _CustomReadMoreTextState createState() => _CustomReadMoreTextState();
}

class _CustomReadMoreTextState extends State<CustomReadMoreText> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded ? widget.text : _getTrimmedText(),
          maxLines: isExpanded ? null : widget.trimLines,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Text(
            isExpanded ? 'Read less' : 'Read more',
            style: TextStyle(color: widget.colorClickableText),
          ),
        ),
      ],
    );
  }

  String _getTrimmedText() {
    String trimmedText = widget.text;
    if (widget.text.length > widget.trimLines) {
      trimmedText = widget.text.substring(0, widget.trimLines) + '...';
    }
    return trimmedText;
  }
}
