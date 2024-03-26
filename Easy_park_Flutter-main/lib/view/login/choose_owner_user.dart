import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/login/welcome_view.dart';
import 'package:easy_park_app/view/owner/welcome_view_owner.dart';
import 'package:flutter/material.dart';

class ChooseOwnerUser extends StatefulWidget {
  const ChooseOwnerUser({super.key});

  @override
  State<ChooseOwnerUser> createState() => _ChooseOwnerUserState();
}

class _ChooseOwnerUserState extends State<ChooseOwnerUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.bg,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/img/welcome_bg.png",
            width: context.width,
            height: context.height,
            fit: BoxFit.cover,
          ),
          Container(
            width: context.width,
            height: context.height,
            color: Colors.black.withOpacity(0.8),
          ),
          SafeArea(
            child: Column(
              children: [
                
                const Spacer(),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: RoundButton(
                    title: "As Owner",
                    onPressed: () {
                      context.push(const WelcomeViewOwner());
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: RoundButton(
                    title: "As User",
                    onPressed: () {
                      context.push(const WelcomeView());
                    },
                  ),
                ),
                // TextButton(
                //   onPressed: () {},
                //   child: Text(
                //     "SIGN UP",
                //     style: TextStyle(
                //       color: TColor.primaryTextW,
                //       fontSize: 16,
                //     )
                //   ),
                // )

                // TextButton(
                //   onPressed: () {
                //      context.push(const SignUpView());
                //   },
                //   child: Text(
                //     "SIGN UP",
                //     style: TextStyle(
                //       color: TColor.primaryTextW,
                //       fontSize: 16,
                //     ),
                //   ),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }
}
