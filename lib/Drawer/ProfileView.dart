import 'dart:io';
import 'package:ISTISHARA/picker/user_image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_password_strength/flutter_password_strength.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../Expert/ExpertType.dart';
import '../Expert/ExpertType.dart';
import 'dart:ui';
import '../Helpers/Helper.dart';
import '../Helpers/ShowDialog.dart';
import '../Database/Databasers.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;

class Profile extends StatefulWidget {
  final String descirbe;
  final String barTitle;
  final bool isProfile;
  List getList() {
    return lst;
  }

  List lst;
  String collection;
  String nbOfRec;

  Profile({
    @required this.descirbe,
    @required this.barTitle,
    @required this.isProfile,
    this.lst,
    this.collection,
    this.nbOfRec,
  });
  @override
  ProfileState createState() => ProfileState(
        describe: descirbe,
        barTitle: barTitle,
        isProfile: isProfile,
        lst: lst,
        collection: collection,
        nbOfRec: nbOfRec,
      );
}

User user;

bool showPassword = true;
bool editableFN = false;
bool editableEmail = false;
bool editablePhone = false;
bool editablePass = false;
bool editableConf = false;
bool editableLN = false;

FirebaseAuth auth = FirebaseAuth.instance;
String id = auth.currentUser.uid;

TextEditingController FirstNameController = TextEditingController();
TextEditingController LastNameController = TextEditingController();
TextEditingController EmailController = TextEditingController();
TextEditingController PhoneController = TextEditingController();
TextEditingController PasswordController = TextEditingController();
TextEditingController ConfirmPasswordController = TextEditingController();
List<TextEditingController> l = [
  FirstNameController,
  LastNameController,
  EmailController,
  PhoneController,
  PasswordController,
  ConfirmPasswordController
];
Helper h = Helper();
Databasers d = Databasers();
FilePickerResult cvRes;

class ProfileState extends State<Profile> {
  var _repValue;
  void _pickedImage(File image) {
    imgRes = image;
  }

  File imgRes;
  String _email,
      _password,
      _firstName,
      _lastName,
      _phoneNumber,
      _error,
      exp,
      _Cpassword;
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
  String collection;
  String nbOfRec;
  ProfileState(
      {@required this.describe,
      @required this.barTitle,
      @required this.isProfile,
      this.lst,
      this.collection,
      this.nbOfRec});
  var x;
  bool flag = false;
  bool toPop = false;
  var profileName;
  var cvName;
  updateData() async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(collection);
    CollectionReference collectionReference2 =
        FirebaseFirestore.instance.collection('conversations');

    if (_firstName != null && _firstName != "") {
      collectionReference.doc(id).update({
        'first name': _firstName,
      });
    }
    if (_lastName != null && _lastName != "") {
      collectionReference.doc(id).update({
        'last name': _lastName,
      });
    }
    if (_email != null && _email != "") {
      collectionReference.doc(id).update({
        'email': _email,
      });
      changeEmail();
    }
    if (_repValue != 0) {
      collectionReference.doc(id).update({
        'price range': _repValue,
      });
    }

    if (_phoneNumber != null && _phoneNumber != "") {
      collectionReference.doc(id).update({
        'phone number': _phoneNumber,
      });
      
    }

    if (imgRes != null) {
      final url = await d.uploadFile(imgRes, context);
      collectionReference.doc(id).update({'image name': url});
      Query collRef = FirebaseFirestore.instance
          .collection('conversations')
          .where('id1', isEqualTo: FirebaseAuth.instance.currentUser.uid);

      Query collRef2 = FirebaseFirestore.instance
          .collection('conversations')
          .where('id2', isEqualTo: FirebaseAuth.instance.currentUser.uid);
      collRef.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          var docid = element.data()['id'];
          collectionReference2.doc(docid).update({'image1': url});
        });
      });
      collRef2.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          var docid = element.data()['id'];
          collectionReference2.doc(docid).update({'image2': url});
        });
      });
      imgRes = null;
    }
    if (cvRes != null) {
      d.uploadFile(File(cvRes.files.single.path), context);
      collectionReference.doc(id).update({
        'CV name': cvRes.names[0].toString(),
      });
      cvRes = null;
    }
    if (_password != null && _password!="")  {
       await collectionReference.doc(id).update({
          'passwoard': _password,
        });
       changePass();
    }

    Navigator.of(context).pop();
  }

  void changePass() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: FirebaseAuth.instance.currentUser.email,
            password: lst[0]['passwoard'])
        .then((_) => print("Successfully signed in"));
    User user1 = await FirebaseAuth.instance.currentUser;
    user1.updatePassword(_password).then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("password can't be changed" + error.toString());
    });
  }

  void changeEmail() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: FirebaseAuth.instance.currentUser.email,
            password: lst[0]['passwoard'])
        .then((_) => print("Successfully signed in"));
    FirebaseAuth.instance.currentUser.updateEmail(_email).then((_) {
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
    setState(() {
      x = img;
    });

    return img;
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    d.cvN;
  }

  @override
  Widget build(BuildContext context) {
    if (_repValue == null) {
      _repValue = 0.0;
    }
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    String reputation = ((lst[0]['reputation'].reduce((a, b) => a + b) /
                    lst[0]['reputation'].length)
                .toDouble() /
            5)
        .toString();
    if (reputation.length > 4) {
      reputation = reputation.substring(0, 4);
    }
    /* if (flag == true) {
      flag = false;
      updateData();
      h.clearInfo(l);
      Timer timer = Timer.periodic(Duration(seconds: 5), (timer) {
        Navigator.of(context).pop();
      });

      return Scaffold(
          body: Container(
        child: Align(
          alignment: Alignment(0, 0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
            strokeWidth: 7,
          ),
        ),
      ));
    } else {*/
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
                onWillPop: () async {
                  Show.showDialogGiveUp(context, "changing information", this,
                      () => {h.clearInfo(l)});
                  return false;
                },
                child: SingleChildScrollView(
                    child: Column(children: [
                  Container(
                      child: Column(children: [
                    Show.showAlert(_error, this),
                    isProfile == true
                        ? UserImagePicker(
                            pickImagefn: _pickedImage,
                            list: lst,
                          )
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
                                      h.buildText(" Reputation:", reputation),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 15,
                                        endIndent: 15,
                                        thickness: 1,
                                      ),
                                      h.buildText("Price:",
                                          lst[0]['price range'].toString()),
                                      VerticalDivider(
                                        color: Colors.black,
                                        indent: 15,
                                        endIndent: 15,
                                        thickness: 1,
                                      ),
                                      h.buildText("Records:", nbOfRec)
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
                          controller: FirstNameController,
                          validator: (String value) {
                            value = value.trim();
                            if (value.length < 3 && value.length >= 1) {
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
                              hintText: "First Name",
                              labelText: lst[0]['first name']),
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
                            controller: LastNameController,
                            validator: (String value) {
                              value = value.trim();
                              if (value.length < 3 && value.length >= 1) {
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
                                labelText: lst[0]['last name'],
                                hintText: "Last Name"),
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
                            controller: EmailController,
                            validator: (String value) {
                              value = value.trim();
                              if (!h.validEmail(value) && value.length >= 1) {
                                return "Incorrect Format";
                              } else {
                                return null;
                              }
                            },
                            readOnly:
                                isProfile == true ? !editableEmail : false,
                            decoration: InputDecoration(
                                isDense: true,
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
                                labelText: lst[0]['email'],
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
                            controller: PhoneController,
                            validator: (String value) {
                              value = value.trim();
                              if (!h.validPhoneNumber(value) &&
                                  value.length > 0) {
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
                                labelText: lst[0]['phone number'],
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
                                  value = value.trim();
                                  if (value.length < 6 && value.length > 0) {
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
                              value = value.trim();
                              if (value != PasswordController.value.text) {
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
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: Colors.purple, width: 1),
                                ),
                              ),
                              child: Column(children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
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
                                ),
                                Container(
                                    height: screenHeight / 10,
                                    padding: EdgeInsets.only(
                                      bottom: screenHeight / 30,
                                    ),
                                    child: OutlinedButton(
                                        onPressed: () {
                                          setState(() async {
                                            cvRes = await d.upload();
                                          });
                                        },
                                        child: Text("Upload CV",
                                            style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w900,
                                                color: Color(0xff5848CF))),
                                        style: ElevatedButton.styleFrom(
                                          side: BorderSide(
                                              width: 3.0,
                                              color: Colors.deepPurple),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(32.0),
                                          ),
                                        ))),
                                d.cvName(),
                                Container(height: screenHeight / 30),
                                Container(
                                  height: screenHeight / 20,
                                  padding: EdgeInsets.only(
                                    left: screenWidth / 25,
                                    right: screenWidth / 25,
                                    bottom: screenHeight / 60,
                                  ),
                                  child: Text("Edit Price:",
                                      style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w900)),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.purple, width: 1),
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Slider(
                                        min: 0,
                                        max: 20,
                                        value: _repValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _repValue = value;
                                          });
                                        },
                                        divisions: 10,
                                        label: _repValue.toString(),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "L.B.P Thousands",
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
                                              } 
                                            }),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // ignore: deprecated_member_use
                                            OutlineButton(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 50),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                onPressed: () {
                                                  editableFN = false;
                                                  editableEmail = false;
                                                  editablePhone = false;
                                                  editablePass = false;
                                                  editableConf = false;
                                                  Show.showDialogGiveUp(
                                                      context,
                                                      "changing information",
                                                      this,
                                                      () => {h.clearInfo(l)});
                                                },
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
                                                        BorderRadius.circular(
                                                            20)),
                                                onPressed: () async {
                                                  setState(() {
                                                    editableFN = false;
                                                    editableEmail = false;
                                                    editablePhone = false;
                                                    editablePass = false;
                                                    editableConf = false;
                                                    flag = true;
                                                    
                                                  });
                                                   if (_formKeyConf.currentState.validate() &&
                                                _formKeyEmail.currentState
                                                    .validate() &&
                                                _formKeyLname.currentState
                                                    .validate() &&
                                                _formKeyPass.currentState
                                                    .validate() &&
                                                _formKeyPhone.currentState
                                                    .validate() && _formKeyFname.currentState.validate()) 
                                                   await  updateData();
                                                    h.clearInfo(l);
                                                },
                                                elevation: 2,
                                                color: Colors.deepPurple,
                                                child: Text("Save",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        letterSpacing: 2.2,
                                                        color: Colors.white))),
                                          ],
                                        ),
                                      ),
                              ])),
                        )
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
                                         if (_formKeyConf.currentState.validate() &&
                                                _formKeyEmail.currentState
                                                    .validate() &&
                                                _formKeyLname.currentState
                                                    .validate() &&
                                                _formKeyPass.currentState
                                                    .validate() &&
                                                _formKeyPhone.currentState
                                                    .validate() && _formKeyFname.currentState.validate()) updateData();
                                            h.clearInfo(l);
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
                                        onPressed: () {
                                          editableFN = false;
                                          editableEmail = false;
                                          editablePhone = false;
                                          editablePass = false;
                                          editableConf = false;
                                          Show.showDialogGiveUp(
                                              context,
                                              "changing information",
                                              this,
                                              () => {h.clearInfo(l)});
                                        },
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
                                        onPressed: () async {
                                          setState(() {
                                            editableFN = false;
                                            editableEmail = false;
                                            editablePhone = false;
                                            editablePass = false;
                                            editableConf = false;
                                            flag = true;
                                            });
                                            if (_formKeyConf.currentState.validate() &&
                                                _formKeyEmail.currentState
                                                    .validate() &&
                                                _formKeyLname.currentState
                                                    .validate() &&
                                                _formKeyPass.currentState
                                                    .validate() &&
                                                _formKeyPhone.currentState
                                                    .validate() && _formKeyFname.currentState.validate())
                                                     await updateData();
                                                     h.clearInfo(l);
                                          
                                        },
                                        elevation: 2,
                                        color: Colors.deepPurple,
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
