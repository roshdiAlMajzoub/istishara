import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:ISTISHARA/LOGIN-SIGNUP/Log_in.dart';
import "package:flutter/material.dart";
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';

class Show {
  static get child => null;

  static Future<AlertDialog> showDialogGiveUp(BuildContext context,
      String giveUpWhat, State widget, Function clearInfo) {
    return showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Text(
                "Give up?!",
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
              ),
              content: Text("Are you sure you want to give up on " +
                  giveUpWhat +
                  "?\n\nInformation entered will be disregarded."),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      // ignore: invalid_use_of_protected_member
                      widget.setState(() {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        clearInfo();
                      });
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No"))
              ]);
        });
  }

  static Future<AlertDialog> showDialogEmailVerify(
      String title, String content, String email, BuildContext context1) {
    final double screenWidth = MediaQuery.of(context1).size.width;
    final double screenHeight = MediaQuery.of(context1).size.height;
    return showDialog<AlertDialog>(
        context: context1,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Text(
                "Email Verification",
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
              ),
              content: Text("An Email verification has been sent to: " +
                  email +
                  "\nPlease verify!"),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => Loginscreen()));
                    },
                    child: Text("OK")),
              ]);
        });
  }

  static Future<AlertDialog> showDialogChooseProfession(BuildContext context1) {
    final double screenWidth = MediaQuery.of(context1).size.width;
    final double screenHeight = MediaQuery.of(context1).size.height;
    return showDialog<AlertDialog>(
        context: context1,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Text(
                "Please choose your profession",
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK")),
              ]);
        });
  }

  static Future<AlertDialog> showDialogDeleteAccount(
      BuildContext context1, Function() delete) {
    final double screenWidth = MediaQuery.of(context1).size.width;
    final double screenHeight = MediaQuery.of(context1).size.height;
    return showDialog<AlertDialog>(
        context: context1,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Text(
                "Are you sure you want to delete your account?!:(",
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w900),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      delete();
                      Navigator.of(context).pushReplacementNamed("/Login");
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.red),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No")),
              ]);
        });
  }

  static Future<AlertDialog> showDialogMeetingDetails(BuildContext context1,
      String title, String startTime, String endTime, String date) {
    return showDialog<AlertDialog>(
        context: context1,
        builder: (BuildContext context) {
          final double screenWidth = MediaQuery.of(context1).size.width;
          final double screenHeight = MediaQuery.of(context1).size.height;
          int endTimeint = DateTime.now().millisecondsSinceEpoch +
              1000 *
                  ((DateTime.now()
                          .difference(DateTime.parse(startTime))
                          .inSeconds)
                      .abs()); 
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            title: Center(
                child: Column(children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
              ),
              Divider(endIndent: 10, indent: 10, thickness: 2),
            ])),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState1) {
              return SingleChildScrollView(
                  child: Container(
                alignment: Alignment.center,
                width: screenWidth,
               
                child: Column(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(children: [
                      Text(
                        "Date: ",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(date,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w900))
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(children: [
                      Text(
                        "Start Time: ",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w900),
                      ),
                      Text(startTime.substring(11, 16),
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w900))
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Row(children: [
                        Text("End Time: ",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.w900)),
                        Text(endTime,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900))
                      ])),
                  SizedBox(
                    height: screenHeight / 20,
                  ),
                  Divider(
                    endIndent: 10,
                    indent: 10,
                    thickness: 2,
                  ),
                  SizedBox(
                    height: screenHeight / 20,
                  ),
                  Center(
                    child: Row(
                      children: [
                        Container(
                            child: Text(
                          "Time Left: ",
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w900),
                        )),
                        SizedBox(
                          width: 20,
                        ),
                        CountdownTimer(
                          textStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w900),
                          endTime: endTimeint,
                          onEnd: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                          child: FlatButton(
                              onPressed: Navigator.of(context).pop,
                              child: Text(
                                "OK",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.w900),
                              )))),
                ]),
              ));
            }),
          );
        });
  }

  static Widget showAlert(String error, State widget) {
    if (error != null) {
      return Container(
        color: Colors.yellow,
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
                error,
                maxLines: 3,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      widget.setState(() {
                        error = null;
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
  
}
