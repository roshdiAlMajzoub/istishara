import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Calendar.dart';
import 'DashBoard.dart';
import 'Login.dart';
import 'Profile.dart';
import 'Settings.dart';

class NavDrawer extends StatelessWidget {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
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
            leading: Icon(Icons.person_outline_rounded),
            title: Text('Profile'),
            onTap: () => { Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Profile()))},
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
                  context, MaterialPageRoute(builder: (_) => Dashboard()))
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Settings()))},
          ),
           ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Feedback'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              auth.signOut();
              Navigator.of(context).pushReplacementNamed('/Login');
            },
          ),
        ],
      ),
    );
  }
}
