import 'package:cloud_firestore/cloud_firestore.dart';

class DataBaseServiceHelp {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('help_seekers');

  final String uid;
  DataBaseServiceHelp({this.uid});
  Future updateuserData(fname, lname, pnumber, email) async {
    return await collectionReference.doc(uid).set({
      'first name': fname,
      'last name': lname,
      'email': email,
      'phone number': pnumber,
    });
  }
}


class DataBaseServiceExperts {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('Experts');

  final String uid;
  DataBaseServiceExperts({this.uid});
  Future updateuserData(fname, lname, pnumber, email, exp) async {
    return await collectionReference.doc(uid).set({
      'first name': fname,
      'last name': lname,
      'email': email,
      'phone number': pnumber,
      'expertise': exp,
    });
  }
}