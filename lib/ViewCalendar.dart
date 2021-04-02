import 'package:ISTISHARA/Helper.dart';
import 'package:ISTISHARA/Time.dart';
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
  ViewCalendar(
      {@required this.id,
      @required this.name,
      @required this.field,
      @required this.color});
  @override
  State<ViewCalendar> createState() => _ViewCalendarState(
      id: this.id, name: this.name, field: this.field, color: this.color);
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
  final format = DateFormat("yyyy-MM-dd");
  _ViewCalendarState(
      {@required this.id,@required this.name, @required this.field, @required this.color});
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: Text(name.split(' ')[0]+" 's Calendar",style: TextStyle(fontSize: 15),),
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
                                print("yes");
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
