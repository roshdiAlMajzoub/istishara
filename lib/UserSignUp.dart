import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:istishara_test/Database.dart';
import 'package:istishara_test/Login.dart';
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

final _PasswordController = TextEditingController();
final _ConfirmPasswordController = TextEditingController();
final _FirstNameController = TextEditingController();
final _LastNameController = TextEditingController();
final _PhoneController = TextEditingController();
final _EmailController = TextEditingController();
void clearInfo() {
  _PasswordController.clear();
  _ConfirmPasswordController.clear();
  _FirstNameController.clear();
  _LastNameController.clear();
  _PhoneController.clear();
  _EmailController.clear();
}

int radioValue = 0;

class _USignUpState extends State<UserSignUp> {
  String _email, _password, _firstName, _lastName, _phoneNumber, exp, _error;
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;

  Future<void> signup() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      await DataBaseServiceExperts(uid: userCredential.user.uid)
          .updateuserData(_firstName, _lastName, _phoneNumber, _email, exp);
      //Navigator.push(context, MaterialPageRoute(builder: (_) => DashboardScreen()));
    } catch (e) {
      setState(() {
        _error = e.message;
        print(_error);
      });
      print(e);
    }
    if (_error == null) {
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified();
      });
    }
  }

  Widget showAlert() {
    if (_error != null) {
      return Container(
        color: Colors.yellow,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                _error,
                maxLines: 3,
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _error = null;
                      });
                    }))
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  Future<void> checkEmailVerified() async {
    _showDialog("Account Verification",
        "An Email verification has been sent to: ", context);
    user = auth.currentUser;
    user.sendEmailVerification();
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginDemo()));
    }
  }

  void _showDialog(String title, String content, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            title: Center(
                child: Text(
              title,
              style: TextStyle(
                  color: Colors.deepPurple, fontWeight: FontWeight.w900),
            )),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState1) {
              return SingleChildScrollView(
                  child: Container(
                alignment: Alignment.center,
                width: screenWidth / 1.8,
                height: screenHeight / 7,
                child: Column(children: [
                  Container(
                      //width: double.infinity,
                      child: Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.w900),
                  )),
                  Container(
                      child: Text(
                    _email,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.deepPurple, fontWeight: FontWeight.w900),
                  )),
                  Container(
                    child: Text(
                      'Please verify!',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.w900),
                    ),
                  )
                ]),
              ));
            }),
          );
        });
  }

  /*void _showDialog(String title, String content, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Center(
                  child: Text(
                title,
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
              )),
              content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState1) {
                return SingleChildScrollView(
                    child: Container(
                  height: screenHeight / 3,
                  child: Column(children: [
                    Container(
                        width: double.infinity,
                        child: Text(
                          content,
                          style: TextStyle(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w900),
                        )),
                    Container(
                        width: double.infinity,
                        child: Row(children: [
                          Align(
                              alignment: Alignment(-1, 0),
                              child: Radio<int>(
                                activeColor: Colors.deepPurple,
                                value: 0,
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState1(() {
                                    radioValue = value;
                                  });
                                },
                              )),
                          Text(_email)
                        ])),
                    Container(
                        width: double.infinity,
                        child: Row(children: [
                          Align(
                              alignment: Alignment(-1, 0),
                              child: Radio<int>(
                                activeColor: Colors.deepPurple,
                                value: 1,
                                groupValue: radioValue,
                                onChanged: (value) {
                                  setState1(() {
                                    radioValue = value;
                                  });
                                },
                              )),
                          Text(_phoneNumber)
                        ])),
                    Padding(
                      padding: EdgeInsets.only(
                          top: screenHeight / 50, bottom: screenHeight / 50),
                      child: Text(
                        "Please insert the code sent to you here:",
                        style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Container(
                        height: screenHeight / 15,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            hintText: "Verification Code",
                          ),
                          textAlignVertical: TextAlignVertical(y: 1),
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15),
                        )),
                  ]),
                ));
              }),
              actions: <Widget>[
                TextButton(onPressed: signup, child: Text("Verify"))
              ]);
        });
  }*/

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

  static final _formKeyFname = GlobalKey<FormState>();
  static final _formKeyLname = GlobalKey<FormState>();
  static final _formKeyEmail = GlobalKey<FormState>();
  static final _formKeyPhone = GlobalKey<FormState>();
  static final _formKeyPass = GlobalKey<FormState>();
  static final _formKeyConf = GlobalKey<FormState>();
  void _showDialog2(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              insetPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
              ),
              title: Text(
                "Give up?!",
                style: TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.w900),
              ),
              content: Text(
                  "Are you sure you want to give up on setting up your account?\n\nInformation entered will be disregarded."),
              actions: <Widget>[
                TextButton(
                    onPressed:(){
                       setState(() {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        clearInfo();
                      });
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No"))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
        onWillPop: () async {
          _showDialog2(context);
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
                title: Text("Help-Seeker Set up Account",
                    style: TextStyle(
                      fontSize: 18,
                    ))),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: screenHeight / 20,
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
                        controller: _FirstNameController,
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
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18),
                      ),
                    ),
                  ),
                    Container(height: screenHeight / 10,
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
                      controller: _LastNameController,
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
                      controller: _EmailController,
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
                      controller: _PhoneController,
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
                        } else if (value.length < 6) {
                          return "Password has to be at least 6 characters long.";
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
                      controller: _ConfirmPasswordController,
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
              Container(height: screenHeight / 20),
              Container(
                height: screenHeight / 10,
                padding: EdgeInsets.only(
                  bottom: screenHeight / 30,
                ),
                child: RaisedButton(
                    color: Colors.deepPurple,
                    child: Text(
                      "Create Account",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900),
                    ),
                    onPressed: () {
                      if (_formKeyFname.currentState.validate() &&
                          _formKeyLname.currentState.validate() &&
                          _formKeyEmail.currentState.validate() &&
                          _formKeyPhone.currentState.validate() &&
                          _formKeyPass.currentState.validate() &&
                          _formKeyConf.currentState.validate()) {
                        signup();
                      }
                    }),
              )
            ],
          ),
        )));
  }
}
