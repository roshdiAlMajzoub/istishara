import 'package:ISTISHARA/NotificationsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Credentials.dart';
import 'DashBoard.dart';
import 'Databasers.dart';
import 'Login.dart';
import 'dart:async';
import 'package:loading_animations/loading_animations.dart';
import 'dart:math';
import './Start.dart';
import 'package:connectivity/connectivity.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Display());
}

class Display extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: DisplayDemo(),
      routes: <String, WidgetBuilder>{
        '/Display': (BuildContext context) => DisplayDemo(),
        '/Start': (BuildContext context) => StartApp(),
        '/ExpertSU': (BuildContext context) => Credentials(descirbe: "Expert", barTitle: "Expert Sign Up",isProfile:false),
        '/UserSU': (BuildContext context) =>Credentials(descirbe: "User",barTitle: "Help-Seeker Sign Up",isProfile: false,),
        '/UserMain': (BuildContext context) => Dashboard(type:"Help-Seeker"),
        '/ExpertMain': (BuildContext context) => Dashboard(type: "Expert",),
        '/Login': (BuildContext context) => MyApp(),
        '/EProfile': (BuildContext context) => Credentials(descirbe: "Expert Profile", barTitle: "Expert Profile", isProfile: true),
        '/UProfile': (BuildContext context) => Credentials(descirbe: "Help-Seeker Profile", barTitle: "Help-Seeker Profile", isProfile: true),
        '/Notifications':(BuildContext context)=> NotificationsPage(dynamic),
      },
    );
  }
}

enum AuthStatus {NotLoggedIn,LoggedIn}

class DisplayDemo extends StatefulWidget {
  @override
  _DisplayState createState() => _DisplayState();
}

var connect = Connectivity();
String connection = "Disconnected";
int a = 0;

void _showDialog(String title, String content, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Text("You are " + title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("Close"))
            ]);
      });
}


String onStartUp()
{
  String val = "failed";
  try {
         FirebaseAuth _auth = FirebaseAuth.instance;
         User user = _auth.currentUser;
         String email = user.email;
         String uid = user.uid;
         val = "success";
         } catch(e)
         {
           return val;
         }
         return val;
}

class _DisplayState extends State<DisplayDemo> {

  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      while (connection == "Disconnected") {
        await Future.delayed(Duration(seconds: 6));
        var response = await connect.checkConnectivity();
        if (response == ConnectivityResult.mobile ||
            response == ConnectivityResult.wifi) {
          connection = "Connected";
          try{
              FirebaseAuth _auth = FirebaseAuth.instance;
              User user = _auth.currentUser;
              String uid = user.uid;
              bool docExists = await d.checkIfDocExists(uid,"help_seekers");
              if (docExists==true) {
              Navigator.of(context).pushNamed('/UserMain');
            } else {
              Navigator.of(context).pushNamed('/ExpertMain');
              }
            } catch(e)
            {
             Navigator.of(context).pushNamed('/Start');
            }



         }
        a++;
        if (a == 2) {
          _showDialog(connection,
              "Please check your Internet Connection and try again", context);
          break;
        }
      }
    });
  }

  List<String> listImages = [
    'asset/images/nb1.png',
    'asset/images/nb2.png',
    'asset/images/nb3.png',
    'asset/images/nb4.png',
    'asset/images/nb5.png',
    'asset/images/nb6.png',
    'asset/images/nb7.png',
    'asset/images/nb8.png',
    'asset/images/nb9.png',
    'asset/images/nb10.png',
  ];
  Random rnd;

  List<String> tips = [
    "“You’re off to great places, today is your day. Your mountain is waiting, so get on your way.”",
    "“You always pass failure on the way to success.”",
    "“No one is perfect - that’s why pencils have erasers.”",
    "“You’re braver than you believe,and stronger than you seem, and smarter than you think.”",
    "“It always seems impossible until it is done.”",
    "“Positive thinking will let you do everything better than negative thinking will.”",
    "“In every day, there are 1,440 minutes.That means we have 1,440 daily opportunities to make a positive impact.”",
    "“The only time you fail is when you fall down and stay down.”",
    "“Positive anything is better than negative nothing.”",
    "“When you are enthusiastic about what you do, you feel this positive energy. It’s very simple.”",
  ];
  int imageNb() {
    int min = 0;
    int max = listImages.length - 1;
    rnd = new Random();
    int r = min + rnd.nextInt(max - min);
    return r;
  }

  int tipNb() {
    int min = 0;
    int max = tips.length - 1;
    rnd = new Random();
    int r = min + rnd.nextInt(max - min);
    return r;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Container(
              height: screenHeight / 2,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 0,
                    top: screenHeight / 13,
                    right: 0,
                    bottom: screenHeight / 10),
                child: Image.asset(listImages[imageNb()]),
              )),
          Padding(
              padding: EdgeInsets.only(
                  left: screenWidth / 16,
                  top: screenHeight / 11,
                  right: screenWidth / 16,
                  bottom: screenHeight / 15),
              child: Text(
                tips[tipNb()],
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17),
              )),
          LoadingFadingLine.circle(
            borderColor: Colors.purple[900],
            borderSize: 3.0,
            size: 50.0,
            backgroundColor: Colors.deepPurple,
            duration: Duration(milliseconds: 1000),
          )
        ]));
  }
}

