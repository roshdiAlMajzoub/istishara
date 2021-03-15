import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:istishara_test/Database.dart';
import 'ExpertType.dart';
import 'dart:ui';

import 'package:flutter/material.dart';

class UserSU extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserSignUp();
  }
}



class UserSignUp extends StatefulWidget {
  @override
  _USignUpState createState() => _USignUpState();
}

class _USignUpState extends State<UserSignUp> {
  String _email, _password, _firstName, _lastName, _phoneNumber;

  Future<void> signup() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      await DataBaseServiceHelp(uid: userCredential.user.uid)
          .updateuserData(_firstName, _lastName, _phoneNumber, _email);
      Navigator.push(context, MaterialPageRoute(builder: (_) => Experts()));
    } catch (e) {
      print(e);
    }
  }

  bool validEmail(String email) {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  bool validPhoneNumber(String number) {
    try {
      int.parse(number);
    } on Exception {
      return false;
    }
    var validPrefixes = ["79", "78", "03", "81", "70"];
    String prefix = number.substring(0, 2);
    if (number.length == 8 && validPrefixes.contains(prefix)) {
      return true;
    }
    return false;
  }

  final _PasswordController = TextEditingController();
  final _ConfirmPasswordController = TextEditingController();
  static final _formKeyFname = GlobalKey<FormState>();
  static final _formKeyLname = GlobalKey<FormState>();
  static final _formKeyEmail = GlobalKey<FormState>();
  static final _formKeyPhone = GlobalKey<FormState>();
  static final _formKeyPass = GlobalKey<FormState>();
  static final _formKeyConf = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    _PasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: Text("Expert Set up Account",
                style: TextStyle(
                  fontSize: 20,
                ))),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: screenHeight / 10,
                padding: EdgeInsets.only(top: screenHeight / 25, bottom: 0),
                child: Text(
                  "Get Started with Istishara!",
                  style: TextStyle(fontSize: 25, color: Colors.deepPurple),
                ),
              ),
              Container(
                height: screenHeight / 10,
                padding: EdgeInsets.only(
                  left: screenWidth / 25,
                  right: screenWidth / 25,
                  bottom: screenHeight / 40,
                ),
                child: Form(
                  key: _formKeyFname,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _firstName = value.trim();
                      });
                    },
                    onTap: () {
                      setState(() {
                        _formKeyFname.currentState.reset();
                      });
                    },
                    textAlignVertical: TextAlignVertical(y: 1),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return "This field cannot be Empty";
                      } else if (value.length < 3) {
                        return "First name has to be at least 3 characters long";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                        ),
                        hintText: "Do not use nick names",
                        labelText: "First Name"),
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                  ),
                ),
              ),
              Container(
                height: screenHeight / 10,
                padding: EdgeInsets.only(
                  left: screenWidth / 25,
                  right: screenWidth / 25,
                  bottom: screenHeight / 40,
                ),
                child: Form(
                    key: _formKeyLname,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _lastName = value;
                        });
                      },
                      onTap: () {
                        setState(() {
                          _formKeyLname.currentState.reset();
                        });
                      },
                      textAlignVertical: TextAlignVertical(y: 1),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field cannot be Empty";
                        } else if (value.length < 3) {
                          return "Last name has to be at least 3 characters long";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.deepPurple,
                          ),
                          labelText: "Last Name",
                          hintText: "Your Family Name"),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    )),
              ),
              Container(
                height: screenHeight / 10,
                padding: EdgeInsets.only(
                  left: screenWidth / 25,
                  right: screenWidth / 25,
                  bottom: screenHeight / 40,
                ),
                child: Form(
                    key: _formKeyEmail,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _email = value.trim();
                        });
                      },
                      onTap: () {
                        setState(() {
                          _formKeyEmail.currentState.reset();
                        });
                      },
                      textAlignVertical: TextAlignVertical(y: 1),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field cannot be Empty";
                        } else if (!validEmail(value)) {
                          return "Incorrect Format";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.deepPurple,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          labelText: "E-mail",
                          hintText: "Enter valid email as abc@example.com"),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    )),
              ),
              Container(
                height: screenHeight / 10,
                padding: EdgeInsets.only(
                  left: screenWidth / 25,
                  right: screenWidth / 25,
                  bottom: screenHeight / 40,
                ),
                child: Form(
                    key: _formKeyPhone,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _phoneNumber = value.trim();
                        });
                      },
                      onTap: () {
                        setState(() {
                          _formKeyPhone.currentState.reset();
                        });
                      },
                      textAlignVertical: TextAlignVertical(y: 1),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field cannot be Empty";
                        } else if (!validPhoneNumber(value)) {
                          return "Incorrect Format";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.phone,
                            color: Colors.deepPurple,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          labelText: "Phone Number",
                          hintText: "8-digits Number"),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    )),
              ),
              Container(
                height: screenHeight / 10,
                padding: EdgeInsets.only(
                  left: screenWidth / 25,
                  right: screenWidth / 25,
                  bottom: screenHeight / 40,
                ),
                child: Form(
                    key: _formKeyPass,
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _password = value.trim();
                        });
                      },
                      onTap: () {
                        setState(() {
                          _formKeyPass.currentState.reset();
                        });
                      },
                      textAlignVertical: TextAlignVertical(y: 1),
                      controller: _PasswordController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field cannot be Empty";
                        } else if (value.length < 4) {
                          return "Password has to be at least 4 characters long.";
                        } else {
                          return null;
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.deepPurple,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          labelText: "Password",
                          hintText:
                              "Strong Password is at least 8 character long."),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    )),
              ),
              Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth / 15,
                    right: screenWidth / 15,
                    bottom: screenHeight / 40,
                  ),
                  child: FlutterPasswordStrength(
                      password: _PasswordController.value.text,
                      strengthCallback: (strength) {
                        debugPrint(strength.toString());
                      })),
              Container(
                height: screenHeight / 10,
                padding: EdgeInsets.only(
                  left: screenWidth / 25,
                  right: screenWidth / 25,
                  bottom: screenHeight / 40,
                ),
                child: Form(
                    key: _formKeyConf,
                    child: TextFormField(
                      onTap: () {
                        setState(() {
                          _formKeyConf.currentState.reset();
                        });
                      },
                      textAlignVertical: TextAlignVertical(y: 1),
                      validator: (String value) {
                        if (value.isEmpty) {
                          return "This field cannot be Empty";
                        } else if (value != _PasswordController.value.text) {
                          return "Password Mismatch";
                        } else {
                          return null;
                        }
                      },
                      obscureText: true,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.deepPurple,
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0)),
                          labelText: "Confirm Password",
                          hintText: "Re-enter your password"),
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
                    )),
              ),
              Container(
                  height: screenHeight / 10,
                  child: Align(
                    alignment: Alignment(1, 0),
                    child: FlatButton(
                      onPressed: () {
                        if (_formKeyFname.currentState.validate() &&
                            _formKeyLname.currentState.validate() &&
                            _formKeyEmail.currentState.validate() &&
                            _formKeyPhone.currentState.validate() &&
                            _formKeyPass.currentState.validate() &&
                            _formKeyConf.currentState.validate()) {
                          signup();
                          
                        }
                      },
                      child: Text(
                        'Next',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 18),
                      ),
                    ),
                  ))
            ],
          ),
        ));
  }
}
