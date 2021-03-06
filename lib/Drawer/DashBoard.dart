import 'package:ISTISHARA/Database/Database.dart';
import 'package:ISTISHARA/Database/Databasers.dart';
import 'package:ISTISHARA/LOGIN-SIGNUP/constants.dart';
import 'package:ISTISHARA/Drawer/ProfileView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../Expert/ListOfExperts.dart';
import 'package:flutter/material.dart';
import 'nav-drawer.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'dart:io';
import 'package:countup/countup.dart';

class Dashboard extends StatefulWidget {
  final String type;
  final String pass;
  var collection;
  Dashboard({
    @required this.type,
    this.pass,
  });
  @override
  DashboardState createState() => DashboardState(type: type);
}

class DashboardState extends State<Dashboard> {
  final String type;
  final String pass;
  bool isExtended = false;
  bool isLoading = true;
  DashboardState({@required this.type, this.pass});

  void _switchActionBar() {
    setState(() {
      isExtended = !isExtended;
    });
  }

  Databasers d = Databasers();
  var collection;
  getCollection() async {
    var coll = await d.docExistsIn(auth.currentUser.uid);
    setState(() {
      collection = coll;
    });
    await getToken();
  }

  @override
  void initState() {
    getCollection();
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(context, '/Notifications');
    });
  }

  String token;
  getToken() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String t = await FirebaseMessaging.instance.getToken();
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(auth.currentUser.uid)
        .update({'token': t});
  }

  var availableMoney;
  getMyMoney() async {
    await getCollection();
    var docData = await FirebaseFirestore.instance
        .collection(collection)
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    setState(() {
      availableMoney = docData.get('money');
      print(availableMoney.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    getCollection();
    getMyMoney();
    setState(() {
      isLoading = false;
    });
    return Scaffold(
        // backgroundColor: kPrimaryLightColor,
        drawer: NavDrawer(type: type, collection: collection, pass: pass),
        appBar: AppBar(
          title: Text("Dashboard"),
          elevation: .1,
          // backgroundColor: kPrimaryColor,
        ),
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
                    if (isLoading) CircularProgressIndicator(),
                    if (!isLoading)
                      Countup(
                        begin: 0,
                        end: availableMoney == null
                            ? 0
                            : double.parse("$availableMoney"),
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
                    makeDashboardItem(
                        "Lawyer", Icons.account_balance, Colors.orange[600]),
                    makeDashboardItem(
                        "Chemist", Icons.sanitizer, Colors.blue[500]),
                    makeDashboardItem(
                        "Biologist", Icons.biotech, Colors.indigoAccent[700]),
                    makeDashboardItem(
                        "Physicist", Icons.lightbulb, Colors.pink),
                    makeDashboardItem(
                        "Physician", Icons.medical_services, Colors.lime[600]),
                    makeDashboardItem("Developer", Icons.code, Colors.red),
                    makeDashboardItem(
                        "Psychologist", Icons.psychology, Colors.amber[900]),
                    makeDashboardItem(
                        "Civil Engineer", Icons.build, Colors.purple[300]),
                    makeDashboardItem("Electrician",
                        Icons.electrical_services_outlined, Colors.amber[400]),
                    makeDashboardItem(
                        "Dietition", Icons.flaky_rounded, Colors.green),
                    makeDashboardItem(
                        "Personal Trainer", Icons.sports_handball, Colors.pink),
                    makeDashboardItem("Plumber", Icons.plumbing, Colors.purple),
                    makeDashboardItem(
                        "Business Analyst", Icons.business, Colors.grey),
                    makeDashboardItem(
                        "Architect", Icons.apartment_rounded, Colors.indigo),
                    makeDashboardItem(
                        "Handyman", Icons.handyman_outlined, Colors.cyan[900]),
                    makeDashboardItem("Carpenter", Icons.carpenter_outlined,
                        Colors.deepOrange),
                    makeDashboardItem("Interior Designer", Icons.home_outlined,
                        Colors.lightBlue),
                    makeDashboardItem(
                        "BlackSmith", Icons.construction, Colors.pink),
                    makeDashboardItem(
                        "Industrial Engineer", Icons.work, Colors.blueAccent),
                    makeDashboardItem(
                        "Data Scientist", Icons.data_usage, Colors.lightGreen),
                    makeDashboardItem(
                        "IT Specialist", Icons.computer, Colors.black),
                    makeDashboardItem("Phone Electrician", Icons.phone_android,
                        Colors.red[800]),
                  ],
                ),
              ),
            )));
  }

  Card makeDashboardItem(
    String title,
    IconData icon,
    Color col,
  ) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0), color: col),
            child: new InkWell(
              onTap: () {
                print(title);
                print(collection);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ListPage(title, collection)));
              },
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  verticalDirection: VerticalDirection.down,
                  children: <Widget>[
                    SizedBox(
                      height: 50.0,
                    ),

                    Icon(
                      icon,
                      size: 40.0,
                      color: Colors.white,
                    ),
                    //SizedBox(height: 20.0),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: new Text(title,
                          style: new TextStyle(
                              fontSize: 18.0, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            )));
  }
}
