import 'package:ISTISHARA/LOGIN-SIGNUP/Login_Body.dart';
import 'package:ISTISHARA/LOGIN-SIGNUP/constants.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'background.dart';
import 'rounded_button.dart';
import 'Start.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text('Tap back again to Exit'),
        ),
        child: WillPopScope(
            // ignore: missing_return
            onWillPop: () async {
              SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop');
            },
            child: Background(
                child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("WELCOME UP ISTISHARA!",
                      style: TextStyle(
                          color: Colors.purple[200],
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: size.height * 0.03),
                  SvgPicture.asset("asset/icons/chat.svg",
                      height: size.height * 0.45),
                  SizedBox(height: size.height * 0.03),
                  RoundedButton(
                      text: "LOGIN",
                      color: kPrimaryColor,
                      textColor: Colors.white,
                      press: () {
                        Navigator.of(context).pushNamed('/Login');
                      }),
                  RoundedButton(
                      text: "SignUp",
                      color: kPrimaryLightColor,
                      textColor: Colors.black,
                      press: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StartApp()),
                        );
                      }),
                  SizedBox(height: size.height * 0.05),
                  Text("Start Your Journey with ISTISHARA!",
                      style: TextStyle(color: kPrimaryColor)),

                ],
              ),
            ))));
  }
}
