import 'package:ISTISHARA/Databasers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DataBaseServiceHelp {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('help seekers');

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
      'id': uid,
    });
  }
}

class DataBaseList {
  Future getUsersList(coll) async {
    //CollectionReference collectionReference =
    //  FirebaseFirestore.instance.collection(coll);
    List expertList = [];
    Query colcollectionReference = FirebaseFirestore.instance
        .collection(coll)
        .orderBy('reputation', descending: true);
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

class DatabaseBookAppt {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future checkAp(col, userid, st, et) async {
    List ap = [];
    List app = [];
    List conflictAppt = [];
    var a = await FirebaseFirestore.instance
        .collection(col)
        .doc(userid)
        .collection('appt')
        .where('start time', isGreaterThanOrEqualTo: Timestamp.fromDate(st))
        //.where('start time', isLessThanOrEqualTo: Timestamp.fromDate(et))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        ap.add(element.data());
      });
    });
    var b = await FirebaseFirestore.instance
        .collection(col)
        .doc(userid)
        .collection('appt')
        .where('end time', isGreaterThanOrEqualTo: Timestamp.fromDate(st))
        //.where('start time', isLessThanOrEqualTo: Timestamp.fromDate(et))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        app.add(element.data());
      });
    });

    if (ap.length == 0) {
      print("no elements");
    } else {
      for (var i = 0; i < app.length; i++) {
        DateTime dt = app[i]['end time'].toDate();
        bool validEndDate = dt.isBefore(et);
        if (validEndDate) {
          conflictAppt.add(1);
          //print("there is conflict");
        }
      }
      for (var i = 0; i < ap.length; i++) {
        DateTime dt = ap[i]['end time'].toDate();
        //bool validDate = dt.isAfter(et);
        DateTime dateS = ap[i]['start time'].toDate();
        bool validDatee = dateS.isBefore(et);
        /*DateTime val = DateTime.now();
        DateTime v = DateTime.now().add(Duration(hours: 2));
        bool va = v.isBefore(val);*/
        if (validDatee == true) {
          //print(validDatee);
          //print(dt);
          //print(validDate);
          conflictAppt.add(1);
          //print('there is conflict');
        } else {
          //print("there is no conflict");
        }
      }
      if (conflictAppt.length > 0) {
        return true;
      }

      return false;
    }
  }

  Future bookAppt(uid1, uid2, st, et) async {
    List coll = [
      'Plumber',
      'Personal Trainer',
      'Electrician',
      'Data Scientist'
    ];
    User user = auth.currentUser;
    String collection;
    List pe = [];
    for (var col in coll) {
      await FirebaseFirestore.instance
          .collection(col)
          .doc(uid1)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          FirebaseFirestore.instance
              .collection(col)
              .doc(uid1)
              .collection('appt')
              .doc()
              .set({
            'start time': Timestamp.fromDate(st),
            'end time': Timestamp.fromDate(et),
          });

          print(col + " document exist");
        }
      });
    }
    print(pe);
  }
}

class DatabaseAppt {
  Future getAppt(uid) async {
    List appts = [];
    List coll = [
      'Plumber',
      'Personal Trainer',
      'Electrician',
      'Data Scientist'
    ];
    Query colcollectionReference;
    for (var col in coll) {
      Query colcollectionReference = await FirebaseFirestore.instance
          .collection(col)
          .doc(uid)
          .collection('appt');
      try {
        await colcollectionReference.get().then((QuerySnapshot) {
          QuerySnapshot.docs.forEach((element) {
            appts.add(element.data());
          });
        });
      } catch (e) {
        print(e.toString());
      }
    }
    return appts;
  }
}

class DataBaseService {
  /*List proff = [];
  getData() async{
    dynamic prof = await DataBaseService().getCurrentUSerData();
    proff = prof;
    print(proff[0]['first name']);

  
  }*/
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future getCurrentUSerData() async {
    List coll = [
      'Plumber',
      'Personal Trainer',
      'Electrician',
      'Data Scientist'
    ];
    User user = auth.currentUser;
    List profile = [];

    for (var col in coll) {
      await FirebaseFirestore.instance
          .collection(col)
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          profile.add(documentSnapshot.data());
        }
      });
    }
    return profile;
  }
}
