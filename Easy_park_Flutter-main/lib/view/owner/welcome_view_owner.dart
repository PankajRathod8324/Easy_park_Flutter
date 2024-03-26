import 'package:easy_park_app/common/color_extension.dart';
import 'package:easy_park_app/common_widget/round_button.dart';
import 'package:easy_park_app/view/owner/loginOwner.dart';
import 'package:easy_park_app/view/owner/registrationOwner.dart';
import 'package:flutter/material.dart';

class WelcomeViewOwner extends StatefulWidget {
  const WelcomeViewOwner({super.key});

  @override
  State<WelcomeViewOwner> createState() => _WelcomeViewOwnerState();
}

class _WelcomeViewOwnerState extends State<WelcomeViewOwner> {
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
                    title: "Sign In",
                    onPressed: () {
                      context.push(LoginOwner());
                    },
                  ),
                 

                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: RoundButton(
                    title: "Sign Up",
                    onPressed: () {
                      context.push(RegistrationOwner());
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
