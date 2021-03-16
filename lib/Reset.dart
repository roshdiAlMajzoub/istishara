import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './DashBoard.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResetDemo();
  }
}

class ResetDemo extends StatefulWidget {
  @override
  ResetScreen createState() => ResetScreen();
}

class ResetScreen extends State<ResetDemo> {
  String _email;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
          title: Text("Reset Page"),
          elevation: 0,
          backgroundColor: Color(0xFF311B92)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
                height: size.height * 0.2,
                child: Stack(
                  children: <Widget>[
                    Container(
                        height: size.height * 0.2 - 2.7,
                        decoration: BoxDecoration(
                          color: const Color(0xFF311B92),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(36),
                              bottomRight: Radius.circular(36)),
                        ))
                  ],
                )),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Center(
                  child: Container(
                child: Image.asset('asset/images/user.png'),
                width: 200,
                height: 150,
              )),
            ),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _email = value.trim();
                  });
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    labelText: 'Email',
                    hintText: 'Enter valid email id as abc@gmail.com'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 0),
              //padding: EdgeInsets.symmetric(horizontal: 15),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () {
                  auth.sendPasswordResetEmail(email: _email);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              height: 130,
            )
          ],
        ),
      ),
    );
  }
}
