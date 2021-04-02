import 'package:flutter/services.dart';

import 'ListOfExperts.dart';
import 'package:flutter/material.dart';
import 'nav-drawer.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'dart:io';
import 'package:countup/countup.dart';

class Dashboard extends StatefulWidget {
  final String type;
  Dashboard({@required this.type});
  @override
  DashboardState createState() => DashboardState(type: type);
}

class DashboardState extends State<Dashboard> {
  final String type;

  bool isExtended = false;
  DashboardState({@required this.type});

  void _switchActionBar() {
    setState(() {
      isExtended = !isExtended;
    });
  }

  @override
  Widget build(BuildContext context) {
    var availableMoney = 50000;
    return Scaffold(
        drawer: NavDrawer(
          type: type,
        ),
        appBar: AppBar(
            title: Text("Dashboard"),
            elevation: .1,
            backgroundColor: Color(0xff5848CF)),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.green,
          isExtended: isExtended,
          onPressed: () {
            _switchActionBar();
          },
          label: isExtended
              ? Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Icon(
                          Icons.attach_money,
                        )),
                    Countup(
                      begin: 0,
                      end: double.parse("$availableMoney"),
                      duration: Duration(seconds: 2),
                      separator: ',',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                     Text(" L.L"),
                  ],
                )
              : Icon(Icons.attach_money),
        ),
        body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text('Tap back again to Exit'),
            ),
            child: WillPopScope(
              onWillPop: () async {
                SystemChannels.platform
                    .invokeMethod<void>('SystemNavigator.pop');
                return false;
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(3.0),
                  children: <Widget>[
                    makeDashboardItem("Software Engineer", Icons.computer),
                    makeDashboardItem("Civil Engineering", Icons.build),
                    makeDashboardItem("Nutritionist", Icons.flaky_rounded),
                    makeDashboardItem("Plumber", Icons.plumbing),
                    makeDashboardItem("PE", Icons.sports_handball),
                    makeDashboardItem("Handyman", Icons.handyman_outlined),
                    makeDashboardItem("Architect", Icons.apartment_rounded),
                    makeDashboardItem(
                        "Electrician", Icons.electrical_services_outlined),
                    makeDashboardItem("Carpenter", Icons.carpenter_outlined),
                    makeDashboardItem("Interior Designer", Icons.home_outlined),
                    makeDashboardItem("BlackSmith", Icons.construction),
                    makeDashboardItem("Industrial Engineer", Icons.work),
                  ],
                ),
              ),
            )));
  }

  Card makeDashboardItem(
    String title,
    IconData icon,
  ) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Color.fromRGBO(220, 220, 220, 1.0)),
          child: new InkWell(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => ListPage(title,type)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(
                  height: 50.0,
                ),
                Center(
                    child: Icon(
                  icon,
                  size: 40.0,
                  color: Colors.black,
                )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                          new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }
}
