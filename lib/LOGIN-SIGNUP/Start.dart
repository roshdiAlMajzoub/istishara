import 'package:ISTISHARA/LOGIN-SIGNUP/constants.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'background.dart';
import 'rounded_button.dart';
import 'Start.dart';

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _Start();
  }
}

class _Start extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StartState();
  }
}

class _StartState extends State<_Start> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        body: WillPopScope(
            
            onWillPop: () async {
              Navigator.of(context).pop();
            },
            child: Background(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("asset/icons/signup.svg",
                      height: size.height * 0.45),
                  SizedBox(height: size.height * 0.03),
                  RoundedButton(
                      text: "SignUp as an Expert",
                      color: kPrimaryColor,
                      textColor: Colors.white,
                      press: () {
                        Navigator.of(context).pushNamed('/ExpertSU');
                      }),
                  RoundedButton(
                      text: "SignUp as a Help Seeker",
                      color: kPrimaryColor,
                      textColor: Colors.white,
                      press: () {
                        Navigator.of(context).pushNamed('/UserSU');
                      }),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ))));
  }
}
