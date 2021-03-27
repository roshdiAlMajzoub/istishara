import 'package:ISTISHARA/NotificationsPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Calendar.dart';
import 'DashBoard.dart';
import 'Login.dart';
import 'Profile.dart';
import 'Settings.dart';

class NavDrawer extends StatelessWidget {
  final auth = FirebaseAuth.instance;
  final String type;
  NavDrawer({@required this.type});

  @override
  Widget build(BuildContext context) {
    var count = 0;         //retrieve from firebase 
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
              onTap: () {
                if (type == "Expert") {
                  Navigator.pushNamed(context, "/EProfile");
                } else {
                  Navigator.pushNamed(context, "/UProfile");
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
  onTap: ()=>{Navigator.push(
                  context, MaterialPageRoute(builder: (_) => NotificationsPage()))},
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendar'),
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Calendar()))
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
                  context, MaterialPageRoute(builder: (_) => Settings()))
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
