import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/login/sign_in_view.dart';
import 'package:easy_park_app/view/login/sign_up_view.dart';
import 'package:flutter/material.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
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
                Image.asset(
                  "assets/img/img_image_2.png",
                  width: context.width * 0.75,
                ),
                const Spacer(),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: RoundButton(
                    title: "Sign In",
                    onPressed: () {
                      context.push(const SignInView());
                    },
                  ),
                 

                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: RoundButton(
                    title: "Sign Up",
                    onPressed: () {
                      context.push(const SignUpView());
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
