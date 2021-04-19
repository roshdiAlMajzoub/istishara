import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/LOGIN-SIGNUP/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDataBaseNotificationList();
  }

  @override
  Widget build(BuildContext context) {
    fetchDataBaseNotificationList();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return new Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/images/mail.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
            drawer: NavDrawer(
              type: "",
            ),
            backgroundColor: Colors.transparent,
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
                  itemCount:
                      notificationList.length, //depends on firebase count;;
                  itemBuilder: (BuildContext context, int index) {
                    if (notificationList[index]['state2'] == "p") {
                      return SizedBox(
                          height: screenHeight / 7.5,
                          child: Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                                decoration:
                                    BoxDecoration(color: Colors.white38),
                                child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  title: Text("Your appointemnt with ..." +
                                      "has been accepted"),
                                  trailing: Container(
                                      padding: EdgeInsets.only(right: 1.0),
                                      child: IconButton(
                                        icon: SvgPicture.asset(
                                            "asset/images/icons8-checked.svg"),
                                        color: Colors.green,
                                        onPressed: () async {
                                          await knowAcceptedAppt(
                                              notificationList[index]['id']);
                                        },
                                      )),
                                )),
                          ));
                    } else {
                      return SizedBox(
                          height: screenHeight / 6.5,
                          child: Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                                decoration:
                                    BoxDecoration(color: Colors.white38),
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
                                            notificationList[index]['id1'],
                                            notificationList[index]['id'],
                                            notificationList[index]['coll'],
                                            notificationList[index]['id2'],
                                          );
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
                                    icon: SvgPicture.asset(
                                        "asset/images/cancel.svg"),
                                    color: Colors.green,
                                    iconSize: 3,
                                    onPressed: () {
                                      showAlertDialog2(
                                          context,
                                          notificationList[index]['id'],
                                          notificationList[index]['id'],
                                          notificationList[index]['coll'],
                                          notificationList[index]
                                              ['start time']);
                                    },
                                  ),
                                )),
                          ));
                    }
                  }),
            )));
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
    onPressed: () async {
      await acceptAppt(col, id, uid, st);
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

Future<String> getName(String id) async {
  Databasers db = Databasers();
  String name = "";
  String collection = await db.docExistsIn(id);
  Query colcollectionReference =
      FirebaseFirestore.instance.collection(collection);
  await colcollectionReference.get().then((QuerySnapshot) {
    QuerySnapshot.docs.forEach((element) {
      if (element.get('id') == id) {
        name = element.get('first name') + " " + element.get('last name');
      }
    });
  });

  return name;
}

Future<String> getImage(String id) async {
  Databasers db = Databasers();
  String image = "";
  String collection = await db.docExistsIn(id);
  Query colcollectionReference =
      FirebaseFirestore.instance.collection(collection);
  print(collection);
  await colcollectionReference.get().then((QuerySnapshot) {
    QuerySnapshot.docs.forEach((element) {
      if (element.get('id') == id) {
          image = element.get('image name');
      }
    });
  });
  
 
}

acceptAppt(col, id1, uid, id2) async {
  String name1 = await getName(id1);
  String name2 = await getName(id2);
  String image1 = await getImage(id1);
  String image2 = await getImage(id2);
  print("before");
  await FirebaseFirestore.instance
      .collection('Appt')
      .doc(uid)
      .update({'state': "Accepted"});
  print("during");
  await FirebaseFirestore.instance.collection("conversations").doc(uid).set({
    'id1': id1,
    'id2': id2,
    'id': uid,
    'name1': name1,
    'name2': name2,
    'image1': image1,
    'image2': image2,
  });
  print("after");
}

denyAppt(col, id, uid, st) async {
  await FirebaseFirestore.instance.collection('Appt').doc(uid).delete();
}

knowAcceptedAppt(uid) async {
  await FirebaseFirestore.instance.collection('Appt').doc(uid).update({
    'state2': "known",
  });
}
