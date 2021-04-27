import 'dart:async';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_core/firebase_core.dart' as firebase_core;
import 'dart:io' as io;
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Database.dart';
import 'package:flutter/foundation.dart';
import '../Helpers/ShowDialog.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart' as cloud;

var listOfExperts = [
  'Developer',
  'Civil Engineer',
  'Electrician',
  'Dietician',
  'Personal Trainer',
  'Business Analyst',
  'Architect',
  'Plumber',
  'Data Scientist',
  'Industrial Engineer',
  'IT Specialist',
  'BlackSmith',
  'Chemist',
  'Biologist',
  'Physicist',
  'Physician',
  'Psychologist',
  'Handyman',
  'Lawyer'
];

class Databasers {
  final auth = FirebaseAuth.instance;
  Timer timer;
  File CV;
  String cvN;
  FilePickerResult res;
  String _error;
  Future<void> checkEmailVerified(
      User user,
      BuildContext context,
      String email,
      Function clearInfo,
      String firstName,
      lastName,
      phoneNumber,
      emai,
      exp,
      cvN,
      priceRange,
      UserCredential userCredential,passwoard) async {
    Show.showDialogEmailVerify("Account Verification",
        "An Email verification has been sent to: ", email, context);
    user = auth.currentUser;
    await user.reload();
    user.sendEmailVerification();
    if (exp != "help_seekers") {
      uploadFile(CV, context);
    }
    await DataBaseServiceExperts(uid: userCredential.user.uid)
        .updateuserData(firstName, lastName, phoneNumber, email, exp, cvN,priceRange,passwoard);
    clearInfo();
  }

  upload() async {
    //upload from file explorer
    FilePickerResult result = await FilePicker.platform.pickFiles();
    res = result;

    if (result != null) {
      File file = File(result.files.single.path);
      CV = file;
      cvN = CV.path.split('/').last;
      return result;
      //return result.names[0].toString();
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

    final ref = FirebaseStorage.instance
        .ref()
        .child('playground')
        .child('${file.path.split('/').last}');

    final metadata = firebase_storage.SettableMetadata(
        contentType: 'pdf/doc',
        customMetadata: {'picked-file-path': file.path});

    if (kIsWeb) {
      uploadTask = ref.putData(await file.readAsBytes(), metadata);
    } else {
      await ref.putFile(file, metadata);
      final url = await ref.getDownloadURL();
      
      return url;
    }
  }

  Future downloadLink(firebase_storage.Reference ref) async {
    try {
      final link = await ref.getDownloadURL();

      await Clipboard.setData(ClipboardData(
        text: link,
      ));
      return link;
    } catch (e) {
     
    }
   
  }

  Future<void> downloadFile(firebase_storage.Reference ref) async {
    final io.Directory systemTempDir = io.Directory.systemTemp;
    final io.File tempFile = io.File('${systemTempDir.path}/temp-${ref.name}');
    if (tempFile.existsSync()) await tempFile.delete();

    await ref.writeToFile(tempFile);

    return Container(
      child: Text(
        'Success!\n Downloaded ${ref.name} \n from bucket: ${ref.bucket}\n '
        'at path: ${ref.fullPath} \n'
        'Wrote "${ref.fullPath}" to tmp-${ref.name}.txt',
      ),
    );
  }

  Future<void> downloadFileExample() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.path}/Istishara');

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('playground/Lecture28.4up.pdf')
          .writeToFile(downloadToFile);
    } on firebase_core.FirebaseException catch (e) {
      
    }
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
      String exp,
      String cvName,
      double priceRange,
      Function clearInfo) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      checkEmailVerified(user, context, email, clearInfo, firstName, lastName,
          phoneNumber, email, exp, cvN, priceRange, userCredential,password);
    } catch (e) {
      widget.setState(() {
        _error = e.message;
        print("hi");
      });
    }
  }

  Widget cvName() {
    if (cvN != null) {
      String cv = cvN;
      cvN = null;
      return Container(
        child: Text(cv),
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

  Future<String> docExistsIn(String docId) async {
    for (int i = 0; i < listOfExperts.length; i++) {
      bool docExists = await checkIfDocExists(docId, listOfExperts[i]);
      if (docExists == true) {
        return listOfExperts[i];
      }
    }
    return "help_seekers";
  }
}
