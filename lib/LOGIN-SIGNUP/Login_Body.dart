import 'package:ISTISHARA/LOGIN-SIGNUP/TextFieldContainer.dart';
import 'package:ISTISHARA/LOGIN-SIGNUP/constants.dart';
import 'package:ISTISHARA/LOGIN-SIGNUP/rounded_button.dart';
import 'package:ISTISHARA/LOGIN-SIGNUP/rounded_password_field.dart';
import 'package:ISTISHARA/Start.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'RoundedTextField.dart';
import 'login_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/Reset.dart';
import 'package:ISTISHARA/ShowDialog.dart';

// ignore: camel_case_types
class Login_Body extends StatefulWidget {
  const Login_Body({
    Key key,
  }) : super(key: key);

  @override
  _Login_BodyState createState() => _Login_BodyState();
}

TextEditingController email_controller = TextEditingController();
TextEditingController password_controller = TextEditingController();

// ignore: camel_case_types
class _Login_BodyState extends State<Login_Body> {
  bool showPassword = true;
  String _email, _password, _error;
  Databasers d = Databasers();

  Future<void> signin() async {
    if (_email == null) {
      print("enull");
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: _email, password: _password);
      User user = FirebaseAuth.instance.currentUser; //.instance.currentUser;
      if (user.emailVerified) {
        String id = FirebaseAuth.instance.currentUser.uid;
        bool docExists = await d.checkIfDocExists(id, "help_seekers");
        if (docExists == true) {
          showPassword = false;
          Navigator.of(context).pushNamed('/UserMain');
        } else {
          Navigator.of(context).pushNamed('/ExpertMain');
          showPassword = false;
        }
      } else {
        user.sendEmailVerification();
        Show.showDialogEmailVerify("Account Verification",
            "An Email verification has been sent to: ", user.email, context);
      }
    } catch (e) {
      setState(() {
        _error = e.message;
        print("omar");
      });
    }
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.red,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                "Invalid Email or Wrong Password!",
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _error = null;
                      });
                    }))
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/Welcome');
        return false;
      },
      child: SingleChildScrollView(
        child: Login_background(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SvgPicture.asset(
              "asset/icons/login.svg",
              height: size.height * 0.35,
            ),
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
            TextFieldContainer(
              child: RoundedPasswordField(
                onChanged: (value) {
                  setState(() {
                    _password = value.trim();
                  });
                },
                obscure: showPassword,
                onpressed: () => setState(() {
                  showPassword = !showPassword;
                }),
              ),
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                signin();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don't have an Account ?",
                  style: TextStyle(color: kPrimaryColor),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartApp()),
                    );
                  },
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: size.height * 0.05),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResetDemo(),
                      ));
                },
                child: Text("Forgot Password")),
            showAlert(),
          ],
        )),
      ),
    );
  }
}
