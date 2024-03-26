import 'package:easy_park_app/common/color_extension.dart';
import 'package:flutter/material.dart';


class MyCarDetailsView extends StatefulWidget {
  const MyCarDetailsView({super.key});

  @override
  State<MyCarDetailsView> createState() => _MyCarDetailsViewState();
}

class _MyCarDetailsViewState extends State<MyCarDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Image.asset(
            "assets/img/back.png",
            width: 25,
            height: 25,
          ),
        ),
        centerTitle: true,
        title: Column(
          children: [
            Text(
              "Toyota Prius",
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              "AB 1234",
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
