import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:flutter/foundation.dart';
import './ExpertType.dart';
import 'ExpertType.dart';
import 'dart:ui';
import 'Helper.dart';
import 'ShowDialog.dart';
import './Databasers.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;

class Profile extends StatefulWidget {
  final String descirbe;
  final String barTitle;
  final bool isProfile;
  List lst;
  Profile(
      {@required this.descirbe,
      @required this.barTitle,
      @required this.isProfile,
      this.lst});
  @override
  ProfileState createState() => ProfileState(
      describe: descirbe, barTitle: barTitle, isProfile: isProfile, lst: lst);
}

User user;
TextEditingController FirstNameController = TextEditingController();
TextEditingController LastNameController = TextEditingController();
TextEditingController PhoneController = TextEditingController();
TextEditingController EmailController = TextEditingController();
TextEditingController PasswordController = TextEditingController();
TextEditingController ConfirmPasswordController = TextEditingController();
bool showPassword = true;
bool editableFN = false;
bool editableEmail = false;
bool editablePhone = false;
bool editablePass = false;
bool editableConf = false;
bool editableLN = false;
String _email,
    _password,
    _firstName,
    _lastName,
    _phoneNumber,
    _error,
    exp,
    _Cpassword;
FirebaseAuth auth = FirebaseAuth.instance;
String id = auth.currentUser.uid;

Helper h = Helper();
Databasers d = Databasers();

class ProfileState extends State<Profile> {
  final _formKeyFname = GlobalKey<FormState>();
  final _formKeyLname = GlobalKey<FormState>();
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyPhone = GlobalKey<FormState>();
  final _formKeyPass = GlobalKey<FormState>();
  final _formKeyConf = GlobalKey<FormState>();
  final String describe;
  final String barTitle;
  final bool isProfile;
  List lst;
  ProfileState(
      {@required this.describe,
      @required this.barTitle,
      @required this.isProfile,
      this.lst});
  var x;

  updateData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('Software Engineer');
    if (_firstName != null) {
      collectionReference.doc(id).update({
        'first name': _firstName,
      });
    }
    if (_lastName != null) {
      collectionReference.doc(id).update({
        'last name': _lastName,
      });
    }
    if (_email != null) {
      collectionReference.doc(id).update({
        'email': _email,
      });
      await changeEmail();
    }

    if (_phoneNumber != null) {
      collectionReference.doc(id).update({
        'phone number': _phoneNumber,
      });
    }
    if (d.cvN != null) {
      collectionReference.doc(id).update({
        'image name': d.cvN,
      });
      d.uploadFile(d.CV, context);
      x = d.cvN;
    }
    if (_password != null) {
      await changePass();
    }
  }

  void changePass() async {
    User user = await FirebaseAuth.instance.currentUser;
    user.updatePassword(_password).then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("password can't be changed" + error.toString());
    });
  }

  void changeEmail() async {
    User user = await FirebaseAuth.instance.currentUser;
    user.updateEmail(_email).then((_) {
      print("Successfully changed email");
    }).catchError((error) {
      print("email can't be changed" + error.toString());
    });
  }

  viewImage() async {
    var img = await Databasers().downloadLink(firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('playground')
        .child(lst[0]['image name']));

    x = img;

    return img;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    viewImage();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
            title: Text(barTitle,
                style: TextStyle(
                  fontSize: 18,
                ))),
        backgroundColor: Colors.white,
        body: GestureDetector(
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
            child: WillPopScope(
                /*onWillPop: () async {
                  Show.showDialogGiveUp(
                      context,
                      this,
                      () => {
                            h.clearInfo(
                                FirstNameController,
                                LastNameController,
                                PhoneController,
                                EmailController,
                                PasswordController,
                                ConfirmPasswordController)
                          });
                  return false;
                },*/
                child: SingleChildScrollView(
                    child: Column(children: [
                  Container(
                      child: Column(children: [
                    Show.showAlert(_error, this),
                    isProfile == true
                        ? Center(
                            child: Stack(children: [
                            Container(
                                width: screenWidth / 3,
                                height: screenHeight / 3.5,
                                child: FutureBuilder(
                                  future: viewImage(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 4,
                                                color: Theme.of(context)
                                                    .scaffoldBackgroundColor,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  offset: Offset(0, 10),
                                                )
                                              ],
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(x),
                                              )));
                                    }

                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Container(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          strokeWidth: 15.5,
                                        ),
                                      );
                                    }
                                    return Container();
                                  },
                                )
                                /*decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
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
                                      image: NetworkImage(x),
                                          
                                ))*/
                                ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: screenHeight / 6.5,
                                width: screenWidth / 6.5,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  color: Colors.deepPurple,
                                ),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                  ),
                                  onPressed: () {
                                    d.upload();
                                  },
                                ),
                              ),
                            ),
                          ]))
                        : Text(""),
                    describe == "Expert Profile"
                        ? Padding(
                            padding: EdgeInsets.only(bottom: 20),
                            child: Card(
                                color: Colors.white,
                                elevation: 8.0,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 18.0, vertical: 6.0),
                                child: SizedBox(
                                    height: screenHeight / 7,
                                    child: Row(children: [
                                      h.buildText(" Reputation:",
                                          lst[0]['reputation'].toString()),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 15,
                                        endIndent: 15,
                                        thickness: 1,
                                      ),
                                      h.buildText("Price Range:", "2-3 LBP"),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 15,
                                        endIndent: 15,
                                        thickness: 1,
                                      ),
                                      h.buildText("Records:", "10")
                                    ]))))
                        : Text(""),
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
                          initialValue: lst[0]['first name'],
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
                          //controller: FirstNameController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return "This field cannot be Empty";
                            } else if (value.length < 3) {
                              return "First name has to be at least 3 characters long";
                            } else {
                              return null;
                            }
                          },
                          readOnly: isProfile == true ? !editableFN : false,
                          decoration: InputDecoration(
                              suffixIcon: isProfile == true
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          editableFN = !editableFN;
                                          editableEmail = false;
                                          editablePhone = false;
                                          editablePass = false;
                                          editableConf = false;
                                          editableLN = false;
                                        });
                                      })
                                  : null,
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
                            initialValue: lst[0]['last name'],
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
                            //controller: LastNameController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "This field cannot be Empty";
                              } else if (value.length < 3) {
                                return "Last name has to be at least 3 characters long";
                              } else {
                                return null;
                              }
                            },
                            readOnly: isProfile == true ? !editableLN : false,
                            decoration: InputDecoration(
                                suffixIcon: isProfile == true
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            editableLN = !editableLN;
                                            editableEmail = false;
                                            editablePhone = false;
                                            editablePass = false;
                                            editableConf = false;
                                            editableFN = false;
                                          });
                                        })
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: Colors.deepPurple,
                                ),
                                labelText: "Last Name",
                                hintText: "Your Family Name"),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
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
                            initialValue: lst[0]['email'],
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
                            //controller: EmailController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "This field cannot be Empty";
                              } else if (!h.validEmail(value)) {
                                return "Incorrect Format";
                              } else {
                                return null;
                              }
                            },
                            readOnly:
                                isProfile == true ? !editableEmail : false,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.deepPurple,
                                ),
                                suffixIcon: isProfile == true
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            editableEmail = !editableEmail;
                                            editablePhone = false;
                                            editablePass = false;
                                            editableConf = false;
                                            editableFN = false;
                                            editableLN = false;
                                          });
                                        })
                                    : null,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                labelText: "E-mail",
                                hintText:
                                    "Enter valid email as abc@example.com"),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
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
                            initialValue: lst[0]['phone number'],
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
                            //controller: PhoneController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "This field cannot be Empty";
                              } else if (!h.validPhoneNumber(value)) {
                                return "Incorrect Format";
                              } else {
                                return null;
                              }
                            },
                            readOnly:
                                isProfile == true ? !editablePhone : false,
                            decoration: InputDecoration(
                                suffixIcon: isProfile == true
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            editablePhone = !editablePhone;
                                            editableEmail = false;
                                            editablePass = false;
                                            editableConf = false;
                                            editableFN = false;
                                            editableLN = false;
                                          });
                                        })
                                    : null,
                                prefixIcon: Icon(
                                  Icons.phone,
                                  color: Colors.deepPurple,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                labelText: "Phone Number",
                                hintText: "8-digits Number"),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
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
                                controller: PasswordController,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "This field cannot be Empty";
                                  } else if (value.length < 6) {
                                    return "Password has to be at least 6 characters long.";
                                  } else {
                                    return null;
                                  }
                                },
                                obscureText:
                                    isProfile == true ? showPassword : true,
                                readOnly:
                                    isProfile == true ? !editablePass : false,
                                decoration: InputDecoration(
                                    suffixIcon: isProfile == true
                                        ? IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.grey,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                editablePass = !editablePass;
                                                editableEmail = false;
                                                editablePhone = false;
                                                editableConf = false;
                                                editableFN = false;
                                                editableLN = false;
                                              });
                                            })
                                        : null,
                                    prefixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.deepPurple,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    labelText: "Password",
                                    hintText:
                                        "Strong Password is at least 8 character long."),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18)))),
                    Padding(
                        padding: EdgeInsets.only(
                          left: screenWidth / 15,
                          right: screenWidth / 15,
                          bottom: screenHeight / 40,
                        ),
                        child: FlutterPasswordStrength(
                            password: PasswordController.value.text,
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
                            onChanged: (value) {
                              setState(() {
                                _Cpassword = value.trim();
                              });
                            },
                            onTap: () {
                              setState(() {
                                _formKeyConf.currentState.reset();
                              });
                            },
                            textAlignVertical: TextAlignVertical(y: 1),
                            controller: ConfirmPasswordController,
                            validator: (String value) {
                              if (value.isEmpty) {
                                return "This field cannot be Empty";
                              } else if (value !=
                                  PasswordController.value.text) {
                                return "Password Mismatch";
                              } else {
                                return null;
                              }
                            },
                            obscureText: true,
                            readOnly: isProfile == true ? !editableConf : false,
                            decoration: InputDecoration(
                                suffixIcon: isProfile == true
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            editableConf = !editableConf;
                                            editableEmail = false;
                                            editablePhone = false;
                                            editablePass = false;
                                            editableFN = false;
                                            editableLN = false;
                                          });
                                        })
                                    : null,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.deepPurple,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0)),
                                labelText: "Confirm Password",
                                hintText: "Re-enter your password"),
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 18),
                          )),
                    )
                  ])),
                  describe == "Expert" || describe == "Expert Profile"
                      ? Container(
                          child: Column(children: [
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
                                    d.upload();
                                  },
                                  child: Text("Upload CV",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xff5848CF))),
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                        width: 3.0, color: Colors.deepPurple),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32.0),
                                    ),
                                  ))),
                          d.cvName(),
                          Container(height: screenHeight / 20),
                          isProfile == false
                              ? Container(
                                  height: screenHeight / 10,
                                  padding: EdgeInsets.only(
                                    bottom: screenHeight / 30,
                                  ),
                                  child: RaisedButton(
                                      color: Colors.deepPurple,
                                      child: Text(
                                        "Create Account",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      onPressed: () {
                                        if (_formKeyFname.currentState.validate() &&
                                            _formKeyLname.currentState
                                                .validate() &&
                                            _formKeyEmail.currentState
                                                .validate() &&
                                            _formKeyPhone.currentState
                                                .validate() &&
                                            _formKeyPass.currentState
                                                .validate() &&
                                            _formKeyConf.currentState
                                                .validate() &&
                                            h.expertt() != null) {
                                          d.signup(
                                              this,
                                              user,
                                              context,
                                              _email,
                                              _password,
                                              _firstName,
                                              _lastName,
                                              _phoneNumber,
                                              h.expertt(),
                                              d.cvN);
                                        } else {
                                          print("here");
                                        }
                                      }),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ignore: deprecated_member_use
                                    OutlineButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        onPressed: () {},
                                        child: Text("Cancel",
                                            style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 2.2,
                                                color: Colors.black))),
                                    // ignore: deprecated_member_use
                                    RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        onPressed: () {
                                          updateData();
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
                                ),
                        ]))
                      : describe == "User"
                          ? Container(
                              child: Column(children: [
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
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900),
                                      ),
                                      onPressed: () {
                                        if (_formKeyFname.currentState.validate() &&
                                            _formKeyLname.currentState
                                                .validate() &&
                                            _formKeyEmail.currentState
                                                .validate() &&
                                            _formKeyPhone.currentState
                                                .validate() &&
                                            _formKeyPass.currentState
                                                .validate() &&
                                            _formKeyConf.currentState
                                                .validate()) {
                                          d.signup(
                                              this,
                                              user,
                                              context,
                                              _email,
                                              _password,
                                              _firstName,
                                              _lastName,
                                              _phoneNumber,
                                              "help_seekers",
                                              d.cvN);
                                        }
                                      }))
                            ]))
                          : describe == "Help-Seeker Profile"
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ignore: deprecated_member_use
                                    OutlineButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        onPressed: () {},
                                        child: Text("Cancel",
                                            style: TextStyle(
                                                fontSize: 14,
                                                letterSpacing: 2.2,
                                                color: Colors.black))),
                                    // ignore: deprecated_member_use
                                    RaisedButton(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 50),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
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
                              : Text("")
                ])))));
  }
}
