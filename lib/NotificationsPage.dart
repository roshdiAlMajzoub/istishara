import 'package:flutter/material.dart';
import 'Database.dart';
import 'nav-drawer.dart';

// ignore: must_be_immutable
class MainNotificationsPage extends StatelessWidget {
  var t;
  @override
  Widget build(BuildContext context) {
    return new NotificationsPage();
  }
}

// ignore: must_be_immutable
class NotificationsPage extends StatefulWidget {
  NotificationsPage();

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
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
              itemCount: 10, //depends on firebase count;;
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white38),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        leading: Container(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Text(
                            "You have Received a new Notifications",
                            //"John Marlin",

                            ///this should be expert.name where name is the expert's name@roshdiAlMajzoub
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                        ),
                        subtitle: Row(
                          children: <Widget>[],
                        ),
                      )),
                );
              }),
        ));
  }
}
