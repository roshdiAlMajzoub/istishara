import 'package:flutter/material.dart';
import 'Database.dart';
import 'nav-drawer.dart';
import 'ShowDialog.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
              itemCount: 10, //depends on firebase count;;
              itemBuilder: (BuildContext context, int index) {
                return SizedBox(
                    height: screenHeight / 9,
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
                                    showAlertDialog(context);
                                  },
                                )),
                            title: Text("You've Received new Notification"),
                            trailing: IconButton(
                              icon: SvgPicture.asset("asset/images/cancel.svg"),
                              color: Colors.green,
                              iconSize: 3,
                              onPressed: () {
                                showAlertDialog(context);
                              },
                            ),
                          )),
                    ));
              }),
        ));
  }
}

// flutter defined function
showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = FlatButton(
    child: Text("Continue"),
    onPressed: () {},
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
