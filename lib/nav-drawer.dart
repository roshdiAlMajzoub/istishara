import 'dart:async';

import 'package:ISTISHARA/LOGIN-SIGNUP/constants.dart';
import 'package:ISTISHARA/MyCalendar.dart';
import 'package:ISTISHARA/NotificationsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Chat/Conversations.dart';
import 'DashBoard.dart';
import 'ProfileView.dart';
import 'Database.dart';
import 'package:ISTISHARA/Settings.dart' as settings;

class NavDrawer extends StatefulWidget {
  final String type;
  final String collection;
  NavDrawer({@required this.type, this.collection});

  @override
  _NavDrawerState createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchDataBaseList();
  }

  Future getUsersList(String id) async {
    List conversations = [];
    Query colcollectionReference =
        FirebaseFirestore.instance.collection("conversations");
    try {
      await colcollectionReference.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          if ((element.get('id1') == id || element.get('id2') == id) &&
              element.get('start time').toDate().isBefore(DateTime.now())) {
            print("inside if");
            conversations.add(element.data(),);
          }
        });
      });
      return conversations;
    } catch (e) {
      print(e.toString());
    }
  }

  List conversationsList = [];

  fetchDataBaseList() async {
    dynamic resultant =
        await getUsersList(FirebaseAuth.instance.currentUser.uid);

    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        conversationsList = resultant;
      });
      print(conversationsList.length);
    }
  }

  bool _isVisible = true;

  void showToast() {
    setState(() {
      _isVisible = false;
    });
  }

  void showToast1() {
    setState(() {
      _isVisible = true;
    });
  }

  final auth = FirebaseAuth.instance;

  List proff = [];

  getData() async {
    dynamic prof = await DataBaseService()
        .getCurrentUSerData(auth.currentUser.uid, widget.collection);
    proff = prof;
    print(proff[0]['first name']);
  }

  List notificationList = [];

  var number = 0;

  fetchDataBaseNotificationList() async {
    dynamic resultant =
        await DataBaseList().getNotificationList(widget.collection);

    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        number = resultant.length;
      });
    }
  }

  List apptt = [];
  fetchDatabaseAppt() async {
    final User user = auth.currentUser;
    dynamic resultant =
        await DatabaseAppt().getAppt(id, widget.collection) as List;
    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        apptt = resultant;
      });
    }
  }

  getNumberOfRecords( id) async {
    List nbOfRecord = [];
    Query collectionRef = FirebaseFirestore.instance
        .collection("Appt")
        .where('id1', isEqualTo: id)
        .where('state', isEqualTo: "Accepted");
    Query collectionRef2 = FirebaseFirestore.instance
        .collection("Appt")
        .where('id2', isEqualTo: id)
        .where('state', isEqualTo: "Accepted");

    await collectionRef.get().then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((element) {
        nbOfRecord.add(element.data());
      });
    });
    await collectionRef2.get().then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((element) {
        nbOfRecord.add(element.data());
      });
    });
    return nbOfRecord.length.toString();
  }

  @override
  Widget build(BuildContext context) {
    fetchDataBaseNotificationList();
    var count = number;
    if (count == 0) {
      showToast();
    } else {
      showToast1();
    } //retrieve from firebase

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (!_isLoading)
      return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('asset/images/menuu.png'))),
              child: null,
            ),
            ListTile(
                leading: Icon(
                  Icons.person,
                  color: kPrimaryColor,
                ),
                title: Text('Profile'),
                onTap: () async {
                  String nbOFRec = await getNumberOfRecords(
                       FirebaseAuth.instance.currentUser.uid);
                  if (widget.type == "Expert") {
                    await getData();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
                                  descirbe: "Expert Profile",
                                  barTitle: "Expert's Profile",
                                  isProfile: true,
                                  lst: proff,
                                  collection: widget.collection,
                                  nbOfRec: nbOFRec,
                                )));
                  } else {
                    await getData();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
                                  descirbe: "Help-Seeker Profile",
                                  barTitle: "Help-Seeker's Profile",
                                  isProfile: true,
                                  lst: proff,
                                  collection: widget.collection,
                                )));
                  }
                }),
            ListTile(
              leading: new Stack(
                children: <Widget>[
                  new Icon(
                    Icons.notifications,
                    color: kPrimaryColor,
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: new Positioned(
                      right: 0,
                      child: new Container(
                        padding: EdgeInsets.all(1),
                        decoration: new BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 13,
                          minHeight: 13,
                        ),
                        child: new Text(
                          '$count',
                          style: new TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              title: Text('Notifications'),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => NotificationsPage(widget.collection)))
              },
            ),
            ListTile(
              leading: Icon(
                Icons.dashboard,
                color: kPrimaryColor,
              ),
              title: Text('Dashboard'),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => Dashboard(
                              type: widget.type,
                            )))
              },
            ),
            ListTile(
              leading: Icon(
                Icons.calendar_today,
                color: kPrimaryColor,
              ),
              title: Text('Calendar'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => MyCalendar(
                              FirebaseAuth.instance.currentUser.uid,
                              widget.collection,
                            )));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.chat,
                color: kPrimaryColor,
              ),
              title: Text('Chat'),
              onTap: () async {
                setState(() {
                  _isLoading = true;
                });
                await fetchDataBaseList();
                setState(() {
                  _isLoading = false;
                });
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Conversations(conversations: this.conversationsList);
                }));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: kPrimaryColor,
              ),
              title: Text('Settings'),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            settings.Settings(widget.collection, proff)))
              },
            ),
            ListTile(
              leading: Icon(
                Icons.border_color,
                color: kPrimaryColor,
              ),
              title: Text('Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: kPrimaryColor,
              ),
              title: Text('Logout'),
              onTap: () async {
                await auth.signOut();
                Navigator.of(context).pushReplacementNamed('/Login');
              },
            ),
          ],
        ),
      );
  }
}
