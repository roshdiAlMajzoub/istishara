import 'dart:async';

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:istishara_test/Database.dart';
import 'package:istishara_test/Login.dart';
import 'package:path_provider/path_provider.dart';
import './ExpertType.dart';
import 'ExpertType.dart';
import 'dart:ui';
import './DashBoard.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';

import 'package:flutter/material.dart';

class ExpertSU extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpertSignUp();
  }
}

class ExpertSignUp extends StatefulWidget {
  @override
  _ESignUpState createState() => _ESignUpState();
}

final _PasswordController = TextEditingController();
final _ConfirmPasswordController = TextEditingController();
final _FirstNameController = TextEditingController();
final _LastNameController = TextEditingController();
final _PhoneController = TextEditingController();
final _EmailController = TextEditingController();
int radioValue = 0;

class _ESignUpState extends State<ExpertSignUp> {
  String _email,
      _path,
      _password,
      _firstName,
      _lastName,
      _phoneNumber,
      exp,
      _error;

 
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  File CV;
  String cvN;
  FilePickerResult res;

  Widget cvName(name) {
    if (name != null) {
      return Container(
        child: Text(name),
      );
    } else {
      return Container(
        child: Text(""),
      );
    }
  }

  bool expertt() {
    exp = ExpertsState.getExpertType();
    if (exp != null) {
      return true;
    }
    return false;
  }

  upload() async {
    //upload from file explorer
    FilePickerResult result = await FilePicker.platform.pickFiles();
    res = result;

    if (result != null) {
      File file = File(result.files.single.path);
      CV = file;
      cvN = CV.path.split('/').last;
      return CV;
    } else {
      print('not done');
      // User canceled the picker
    }
  }

  uploadFile(File file) async {

    // upload to firebase
    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No file was selected'),
      ));
      return null;
    }
    firebase_storage.UploadTask uploadTask;

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('playground')
        .child('${file.path.split('/').last}');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'pdf/doc',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      uploadTask = ref.putFile(File(file.path), metadata);
    }
//////
    return Future.value(uploadTask);
  }

  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      exp = ExpertsState.getExpertType();
    });
  }

  Future<void> signup() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email, password: _password);
      await DataBaseServiceExperts(uid: userCredential.user.uid)
          .updateuserData(_firstName, _lastName, _phoneNumber, _email, exp);
      uploadFile(CV);
    } catch (e) {
      setState(() {
        _error = e.message;
        print(_error);
      });
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
                TextButton( onPressed:(){Navigator.push( context, MaterialPageRoute(builder: (_) => DashboardScreen()));} , child: Text("Verify"))
              ]);
        });
  }*/

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
              showAlert(),
              Container(height: screenHeight / 20),
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
                height: screenHeight / 20,
                padding: EdgeInsets.only(
                  left: screenWidth / 25,
                  right: screenWidth / 25,
                  bottom: screenHeight / 60,
                ),
                child: Text("Select what best describes you:",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
              ),
              Container(
                height: screenHeight / 10,
                padding: EdgeInsets.only(
                  bottom: screenHeight / 30,
                ),
                child: Experts(),
              ),
              Container(
                height: screenHeight / 20,
                padding: EdgeInsets.only(
                  left: screenWidth / 25,
                  right: screenWidth / 25,
                  bottom: screenHeight / 60,
                ),
                child: Text("Upload your CV:",
                    style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 18,
                        fontWeight: FontWeight.w900)),
              ),
              Container(
                  height: screenHeight / 10,
                  padding: EdgeInsets.only(
                    bottom: screenHeight / 30,
                  ),
                  child: OutlinedButton(
                      onPressed: () {
                        upload();
                      },
                      child: Text("Upload CV",
                          style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Color(0xff5848CF))),
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(width: 3.0, color: Colors.deepPurple),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ))),
              cvName(cvN),
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
                          _formKeyConf.currentState.validate() &&
                          expertt()) {
                        signup();

                        //_showDialog("Account Verification",
                        //  "Verify your Account via:", context);
                      }
                    }),
              )
            ],
          ),
        ));
  }
}
