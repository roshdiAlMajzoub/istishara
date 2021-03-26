import 'package:flutter/material.dart';
import 'nav-drawer.dart';

class MainProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Profile();
  }
}

class Profile extends StatefulWidget {
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  bool showPassword = true;
  bool editableFN = false;
  bool editableEmail = false;
  bool editablePhone = false;
  bool editablePass = false;
  bool editableConf = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(type:"o" ,),
        appBar: AppBar(
            title: Text("Profile"),
            elevation: .1,
            backgroundColor: Color(0xff5848CF)),
        body: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  FocusScope.of(context).unfocus();
                  editableFN = false;
                  editableEmail = false;
                  editablePhone = false;
                  editablePass = false;
                  editableConf = false;
                });
              },
              child: ListView(children: [
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            boxShadow: [
                              BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10),
                              )
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage('asset/images/head.jpg')),
                          )),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.green,
                          ),
                          child: IconButton(
                            icon: Icon(
                              Icons.edit,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                        //obscureText: isPassword ? showPassword : false,
                        readOnly: !editableFN,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  editableFN = !editableFN;

                                  editableEmail = false;
                                  editablePhone = false;
                                  editablePass = false;
                                  editableConf = false;
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                            labelText: "Full Name",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Name",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            )))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                        //obscureText: isPassword ? showPassword : false,
                        readOnly: !editableEmail,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  editableEmail = !editableEmail;
                                  editableFN = false;
                                  editablePhone = false;
                                  editablePass = false;
                                  editableConf = false;
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                            labelText: "Email Address",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "abc@mail.com",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            )))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                        //obscureText: isPassword ? showPassword : false,
                        readOnly: !editablePhone,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  editablePhone = !editablePhone;
                                  editableFN = false;
                                  editableEmail = false;
                                  editablePass = false;
                                  editableConf = false;
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                            labelText: "Phone Number",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "03XXXXXX",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            )))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                        //obscureText: isPassword ? showPassword : false,
                        readOnly: !editablePass,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  editablePass = !editablePass;
                                  editableFN = false;
                                  editableEmail = false;
                                  editablePhone = false;
                                  editableConf = false;
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                            labelText: "Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Choose a strong Password",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            )))),
                Padding(
                    padding: const EdgeInsets.only(bottom: 35.0),
                    child: TextField(
                        //obscureText: isPassword ? showPassword : false,
                        readOnly: !editableConf,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  editableConf = !editableConf;
                                  editableFN = false;
                                  editableEmail = false;
                                  editablePhone = false;
                                  editablePass = false;
                                });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.grey,
                              ),
                            ),
                            labelText: "Confirm Password",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: "Must matches password",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            )))),
                SizedBox(
                  height: 35,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ignore: deprecated_member_use
                    OutlineButton(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {},
                        child: Text("Cancel",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.black))),
                    // ignore: deprecated_member_use
                    RaisedButton(
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () {
                          setState(() {
                            editableFN = false;
                            editableEmail = false;
                            editablePhone = false;
                            editablePass = false;
                            editableConf = false;
                          });
                        },
                        elevation: 2,
                        color: Colors.green,
                        child: Text("Save",
                            style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white))),
                  ],
                )
              ]),
            )));
  }

  Widget buildText(
      String labelText, String placeholder, bool isPassword, bool isWrite) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: TextField(
          //obscureText: isPassword ? showPassword : false,
          readOnly: !isWrite,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isWrite = !isWrite;
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
              ),
              labelText: labelText,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              hintText: placeholder,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              )),
        ));
  }
}
