import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'DashBoard.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 3), (timer) {
      checkEmailVerified();
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            'An Email verification has been sent to ${user.email} please verify'),
      ),
    );
  }

  void _showDialog(String title, String content, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Center(
                  child: Text(
                title,
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
              )),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState1) {
                return SingleChildScrollView(
                    child: Container(
                  height: screenHeight / 3,
                  child: Column(children: [
                    Container(
                        width: double.infinity,
                        child: Text(
                          content,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w900),
                        )),
                  ]),
                ));
              }),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => Dashboard()));
                    },
                    child: Text("Verify"))
              ]);
        });
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }
}
