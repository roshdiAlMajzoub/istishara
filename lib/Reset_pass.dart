import 'package:ISTISHARA/LOGIN-SIGNUP/constants.dart';
import 'package:ISTISHARA/LOGIN-SIGNUP/login_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'LOGIN-SIGNUP/RoundedTextField.dart';
import 'LOGIN-SIGNUP/TextFieldContainer.dart';
import 'LOGIN-SIGNUP/rounded_button.dart';

// ignore: camel_case_types
class Reset_Pass extends StatefulWidget {
  @override
  _Reset_PassState createState() => _Reset_PassState();
}

// ignore: camel_case_types
class _Reset_PassState extends State<Reset_Pass> {
  String _email;
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          return false;
        },
        child: Material(
            child: SingleChildScrollView(
                child: Login_background(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Reset Your Password!",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              SizedBox(height: size.height * 0.05),
              TextFieldContainer(
                child: RoundedInputField(
                  hinText: "YourEmail",
                  onChanged: (value) {
                    setState(() {
                      _email = value.trim();
                    });
                  },
                ),
              ),
              SizedBox(height: size.height * 0.05),
              RoundedButton(
                text: "RESET",
                press: () {
                  auth.sendPasswordResetEmail(email: _email);
                  Navigator.of(context).pop();
                },
              ),
              SizedBox(height: size.height * 0.05),
            ],
          ),
        ))));
  }
}
