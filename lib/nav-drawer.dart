import 'package:ISTISHARA/MyCalendar.dart';
import 'package:ISTISHARA/NotificationsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Calendar.dart';
import 'Credentials.dart';
import 'DashBoard.dart';
import 'Login.dart';
import 'ProfileView.dart';
import 'Settings.dart';
import 'Database.dart';

class NavDrawer extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final String type;
  final String collection;
  List noti;
  NavDrawer({@required this.type, this.collection, this.noti});

  List proff = [];
  getData() async {
    dynamic prof = await DataBaseService()
        .getCurrentUSerData(auth.currentUser.uid, collection);
    proff = prof;
    print(proff[0]['first name']);
  }

  List notificationList = [];
  var number = 0;
  fetchDataBaseNotificationList() async {
    dynamic resultant = await DataBaseList().getNotificationList(collection);

    if (resultant == null) {
      print("unable to retrieve");
    } else {
      number = resultant.length;
      print(notificationList);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("roshdi  roshdi  roshdi");
    print(noti);
    fetchDataBaseNotificationList();
    var count = number; //retrieve from firebase
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('asset/images/menu.png'))),
            child: null,
          ),
          ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () async {
                if (type == "Expert") {
                  await getData();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Profile(
                                descirbe: "Expert Profile",
                                barTitle: "Expert's Profile",
                                isProfile: true,
                                lst: proff,
                                collection: collection,
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
                                collection: collection,
                              )));
                }
              }),
          ListTile(
            leading: new Stack(
              children: <Widget>[
                new Icon(Icons.notifications),
                new Positioned(
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
                )
              ],
            ),
            title: Text('Notifications'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => NotificationsPage(collection)))
            },
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendar'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => MyCalendar(
                            auth.currentUser.uid,
                            collection,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Dashboard(
                            type: type,
                          )))
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => Settings(collection, proff)))
            },
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
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
