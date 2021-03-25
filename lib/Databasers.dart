import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:istishara_test/Database.dart';
import 'package:flutter/foundation.dart';
import 'Login.dart';
import 'ShowDialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;

class Databasers {
  final auth = FirebaseAuth.instance;
  Timer timer;
  File CV;
  String cvN;
  FilePickerResult res;
  String _error;
  Future<void> checkEmailVerified(
      User user, BuildContext context, String email) async {
    Show.showDialogEmailVerify("Account Verification",
        "An Email verification has been sent to: ", email, context);
    user = auth.currentUser;
    user.sendEmailVerification();
    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginDemo()));
    }
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

  uploadFile(File file, BuildContext context) async {
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

  Future<void> signup(
      State widget,
      User user,
      BuildContext context,
      String email,
      String password,
      String firstName,
      String lastName,
      String phoneNumber,
      String exp) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (exp != "help_seekers") {
        await DataBaseServiceExperts(uid: userCredential.user.uid)
            .updateuserData(firstName, lastName, phoneNumber, email, exp);
        uploadFile(CV, context);
      } else {
        await DataBaseServiceHelp(uid: userCredential.user.uid)
            .updateuserData(firstName, lastName, phoneNumber, email);
        checkEmailVerified(user, context, email);
      }
    } catch (e) {
      widget.setState(() {
        _error = e.message;
        print("hi");
      });
    }
    if (_error == null) {
      timer = Timer.periodic(Duration(seconds: 3), (timer) {
        checkEmailVerified(user, context, email);
      });
    }
  }

  Widget cvName() {
    if (cvN != null) {
      return Container(
        child: Text(cvN),
      );
    } else {
      return Container(
        child: Text(""),
      );
    }
  }

  Future<bool> checkIfDocExists(String docId, String collection) async {
    try {
      var collectionRef =
          cloud.FirebaseFirestore.instance.collection(collection);
      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }
}
