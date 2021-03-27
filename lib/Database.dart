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
  final String uid;
  DataBaseServiceExperts({this.uid});
  Future updateuserData(fname, lname, pnumber, email, exp) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(exp);

    return await collectionReference.doc(uid).set({
      'first name': fname,
      'last name': lname,
      'email': email,
      'phone number': pnumber,
      'reputation': 0,
    });
  }
}

class DataBaseList {
  Future getUsersList(coll) async {
    //CollectionReference collectionReference =
      //  FirebaseFirestore.instance.collection(coll);
    List expertList = [];
    Query colcollectionReference =
        FirebaseFirestore.instance.collection(coll).orderBy('reputation', descending: true);
    try {
      await colcollectionReference.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          expertList.add(element.data());
        });
      });
      return expertList;
    } catch (e) {
      print(e.toString());
    }
  }


}
