import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'Database.dart';
import 'nav-drawer.dart';
import 'ShowDialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class MainNotificationsPage extends StatelessWidget {
  var t;
  var collection;
  @override
  Widget build(BuildContext context) {
    return new NotificationsPage(collection);
  }
}

// ignore: must_be_immutable
class NotificationsPage extends StatefulWidget {
  var collection;
  NotificationsPage(collection) {
    this.collection = collection;
  }
  @override
  _NotificationsPageState createState() => _NotificationsPageState(collection);
}

class _NotificationsPageState extends State<NotificationsPage> {
  var collection;
  _NotificationsPageState(collection) {
    this.collection = collection;
  }

  List notificationList = [];

  fetchDataBaseNotificationList() async {
    dynamic resultant = await DataBaseList().getNotificationList(collection);

    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        notificationList = resultant;
      });
      print(notificationList);
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataBaseNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    print(collection);
    fetchDataBaseNotificationList();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return new Scaffold(
        drawer: new NavDrawer(
          type: '',
        ),
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: Color(0x66666),
          title: Text("Notifications"),
          leading: Icon(Icons.notifications),
        ),
        body: new Container(
          child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: notificationList.length, //depends on firebase count;;
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: screenHeight / 6.5,
                    child: Card(
                      elevation: 8.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                          decoration: BoxDecoration(color: Colors.white38),
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading: Container(
                                padding: EdgeInsets.only(right: 12.0),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                      "asset/images/icons8-checked.svg"),
                                  color: Colors.green,
                                  onPressed: () {
                                    showAlertDialog(
                                        context,
                                        notificationList[index]['id'],
                                        notificationList[index]['id'],
                                        notificationList[index]['coll'],
                                        notificationList[index]['start time']);
                                  },
                                )),
                            title: Text("New Meeting at " +
                                notificationList[index]['start time']
                                    .toDate()
                                    .toString() +
                                "-" +
                                notificationList[index]['end time']
                                    .toDate()
                                    .toString()),
                            trailing: IconButton(
                              icon: SvgPicture.asset("asset/images/cancel.svg"),
                              color: Colors.green,
                              iconSize: 3,
                              onPressed: () {
                                showAlertDialog2(
                                    context,
                                    notificationList[index]['id'],
                                    notificationList[index]['id'],
                                    notificationList[index]['coll'],
                                    notificationList[index]['start time']);
                              },
                            ),
                          )),
                    ));
              }),
        ));
  }
}

// flutter defined function
showAlertDialog(BuildContext context, id, uid, col, st) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed: () {
      acceptAppt(col, id, uid, st);
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Are you sure?"),
    content: Text("Would you like to come back to this later?"),
    actions: [
      cancelButton,
      continueButton,
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

showAlertDialog2(BuildContext context, id, uid, col, st) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed: () {
      denyAppt(col, id, uid, st);
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Are you sure?"),
    content: Text("Would you like to come back to this later?"),
    actions: [
      cancelButton,
      continueButton,
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

acceptAppt(col, id, uid, st) async {
  //print(col);
  //print(id);
  print(uid);
  //print(st);
  await FirebaseFirestore.instance
      .collection('Appt')
      .doc(uid)
      .update({'state': "Accepted"});
}

denyAppt(col, id, uid, st) async {
  print(col);
  print(id);
  print(uid);
  print(st);
  await FirebaseFirestore.instance.collection('Appt').doc(uid).delete();
}
