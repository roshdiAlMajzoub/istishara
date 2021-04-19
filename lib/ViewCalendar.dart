import 'package:ISTISHARA/Helper.dart';
import 'package:ISTISHARA/ProfileView.dart';
import 'package:ISTISHARA/Time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Database.dart';
import 'ShowDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Calendar.dart';
import 'nav-drawer.dart';

Helper h = Helper();

class ViewCalendar extends StatefulWidget {
  final String id;
  final String field;
  final MaterialColor color;
  final String name;
  String collection;
  String expId;
  ViewCalendar(
      {@required this.id,
      @required this.name,
      @required this.field,
      @required this.color,
      this.collection});
  @override
  State<ViewCalendar> createState() => _ViewCalendarState(
      id: this.id,
      name: this.name,
      field: this.field,
      color: this.color,
      collection: this.collection);
}

var dateControl = TextEditingController();
var stControl = TextEditingController();
var etControl = TextEditingController();

List<TextEditingController> l = [dateControl, stControl, etControl];

class _ViewCalendarState extends State<ViewCalendar> {
  final GlobalKey<FormState> dateKey = GlobalKey<FormState>();
  final GlobalKey<FormState> stKey = GlobalKey<FormState>();
  final GlobalKey<FormState> etKey = GlobalKey<FormState>();
  final String id;
  final String field;
  final MaterialColor color;
  final String name;
  String collection;
  final format = DateFormat("yyyy-MM-dd");
  _ViewCalendarState({
    @required this.id,
    @required this.name,
    @required this.field,
    @required this.color,
    this.collection,
  });
  bool check;
  hey() async {
    DateTime day = DateTime.parse(dateControl.value.text);
    var x = dateControl.value.text + " " + stControl.value.text + ":00.000";
    var y = dateControl.value.text + " " + etControl.value.text + ":00.000";
    DateTime startTime = DateTime.parse(x);
    DateTime endTime = DateTime.parse(y);
    var h = await getConflictappt(startTime, endTime);
    if (h == false) {
      String token;
      String token2;
      print(collection);
      await FirebaseFirestore.instance
          .collection(field)
          .doc(id)
          .get()
          .then((DocumentSnapshot d) {
        token = d.data()['token'];
      });
      print("before");
      print(collection);
      await FirebaseFirestore.instance
          .collection(collection)
          .doc(auth.currentUser.uid)
          .get()
          .then((DocumentSnapshot d) {
        token2 = d.data()['token'];
      });
      print("After");
      DatabaseBookAppt().bookAppt(
        auth.currentUser.uid,
        collection,
        id,
        field,
        startTime,
        endTime,
        token,
        token2,
      );
      showAlertDialog(context, "Your request has been sent to the expert.",
          "You will recieve notification once your request is approved.");
      print(token);
      print('done');
    } else {
      showAlertDialog(
          context,
          "This appointemnet is in conflict with another one",
          "Try another one!");
      print('not');
    }
    //print(startTime);

    //print(Timestamp.fromDate(startTime));
    //print(endTime);
    //print(Timestamp.fromDate(endTime));
  }

  Future<bool> getConflictappt(st, et) async {
    //final User user = auth.currentUser;
    bool h = await DatabaseBookAppt().checkAp(field, id, st, et);
    setState(() {
      check = h;
    });

    return h;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hey();
  }

  @override
  Widget build(BuildContext context) {
    //getConflictappt();
    //print(collection);
    //print(field);
    //print(id);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: Text(
              name.split(' ')[0] + " 's Calendar",
              style: TextStyle(fontSize: 15),
            ),
            elevation: .1,
            backgroundColor: Color(0xff5848CF)),
        body: GestureDetector(
            onTap: () {
              setState(() {
                FocusScope.of(context).unfocus();
              });
            },
            child: WillPopScope(
                onWillPop: () async {
                  Show.showDialogGiveUp(context, "Booking this consultation",
                      this, () => {h.clearInfo(l)});
                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(children: [
                    Container(
                        height: screenHeight / 2,
                        width: double.infinity,
                        child: Calendar(id, field, Colors.grey)),
                    Padding(
                        padding: EdgeInsets.only(top: 30, bottom: 30),
                        child: Divider(
                          color: Colors.deepPurple,
                          endIndent: 20,
                          indent: 20,
                          thickness: 3,
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            left: screenWidth / 10,
                            right: screenWidth / 10,
                            bottom: screenHeight / 50),
                        height: screenHeight / 15,
                        child: BasicDateField(
                          title: "Choose Date",
                          dateControl: dateControl,
                          dateKey: dateKey,
                        )),
                    Container(
                        padding: EdgeInsets.only(
                            left: screenWidth / 10,
                            right: screenWidth / 10,
                            bottom: screenHeight / 50),
                        height: screenHeight / 15,
                        child: BasicTimeField(
                          title: "Choose Start Time",
                          timeKey: stKey,
                          timeControl: stControl,
                        )),
                    Container(
                        height: screenHeight / 15,
                        padding: EdgeInsets.only(
                            left: screenWidth / 10,
                            right: screenWidth / 10,
                            bottom: screenHeight / 50),
                        child: BasicTimeField(
                          title: "Choose End Time",
                          timeKey: etKey,
                          timeControl: etControl,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ignore: deprecated_member_use
                        OutlineButton(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              Show.showDialogGiveUp(
                                  context,
                                  "Booking this consultation",
                                  this,
                                  () => {h.clearInfo(l)});
                            },
                            child: Text("Cancel",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.black))),
                        // ignore: deprecated_member_use
                        RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            onPressed: () {
                              if (dateKey.currentState.validate() &&
                                  stKey.currentState.validate() &&
                                  etKey.currentState.validate()) {
                                      hey();
                              }
                            },
                            elevation: 2,
                            color: Colors.deepPurple,
                            child: Text("Book",
                                style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2.2,
                                    color: Colors.white))),
                      ],
                    )
                  ]),
                ))));
  }
}

showAlertDialog(BuildContext context, txt, txt1) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(txt),
    content: Text(txt1),
    actions: [
      cancelButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
