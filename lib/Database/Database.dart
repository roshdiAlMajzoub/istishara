import 'dart:convert';
import 'package:ISTISHARA/Database/Databasers.dart';
import 'package:ISTISHARA/Drawer/ProfileView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart' as fcm;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';

class DataBaseServiceHelp {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection('help_seekers');

  final String uid;
  DataBaseServiceHelp({this.uid});
  Future updateuserData(fname, lname, pnumber, email, priceRange,passwoard) async {
    return await collectionReference.doc(uid).set({
      'first name': fname,
      'last name': lname,
      'email': email,
      'passwoard': passwoard,
      'phone number': pnumber,
      'id': uid,
      'money': 50000,
      'image name':"https://firebasestorage.googleapis.com/v0/b/istisharaa.appspot.com/o/playground%2Fprofile1.jpg?alt=media&token=0d539f85-b3b7-462d-83b8-97383993efea",
      'available': true,
      'price range': priceRange*1000,
    });
  }
}

class DataBaseServiceExperts {
  final String uid;
  DataBaseServiceExperts({this.uid});
  Future updateuserData(fname, lname, pnumber, email, exp, cvN, priceRange,passwoard) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(exp);

    return await collectionReference.doc(uid).set({
      'first name': fname,
      'last name': lname,
      'email': email,
      'passwoard': passwoard,
      'phone number': pnumber,
      'reputation': [0],
      'id': uid,
      'CV name': cvN,
      'money': 50000,
      'image name':"https://firebasestorage.googleapis.com/v0/b/istisharaa.appspot.com/o/playground%2Fprofile1.jpg?alt=media&token=0d539f85-b3b7-462d-83b8-97383993efea",
      'available': true,
      'price range': priceRange*1000,
    });
  }
}

class DataBaseList {
  FirebaseAuth auth = FirebaseAuth.instance;
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

  Future getNotificationList(coll) async {
    //CollectionReference collectionReference =
    //  FirebaseFirestore.instance.collection(coll);
    List expertList = [];
    Query colcollectionReference = FirebaseFirestore.instance
        .collection('Appt')
        .where('id2', isEqualTo: auth.currentUser.uid)
        .where('state', isEqualTo: "pending");
    
    Query colcollectionReference2 = FirebaseFirestore.instance
        .collection('Appt')
        .where('id1', isEqualTo: auth.currentUser.uid)
        .where('state2', isEqualTo: "p");
    
    try {
      await colcollectionReference.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          expertList.add(element.data());
        });
      });
      await colcollectionReference2.get().then((QuerySnapshot) {
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
        .collection('Appt')
        .where('id2', isEqualTo: userid)
        //.where('start time', isGreaterThanOrEqualTo: Timestamp.fromDate(st))
        //.where('start time', isLessThanOrEqualTo: Timestamp.fromDate(et))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if ((element.data()['start time'].toDate().isAfter(st)) ||
            (element.data()['start time'].toDate() == (st)) ||
            ((element.data()['start time'].toDate().isBefore(st)) &&
                (element.data()['end time'].toDate().isAfter(st)))) {
          ap.add(element.data());
        }
      });
    });
    var b = await FirebaseFirestore.instance
        .collection('Appt')
        .where('id2', isEqualTo: userid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if ((element.data()['end time'].toDate().isAfter(st)) ||
            (element.data()['end time'].toDate() == (st))) {
          app.add(element.data());
        }
      });
    });

    if (ap.length == 0 && app.length == 0) {
      return false;
  
    } else {
      for (var i = 0; i < app.length; i++) {
        DateTime dt = app[i]['end time'].toDate();
        bool validEndDate = dt.isBefore(et);
        if (validEndDate) {
          conflictAppt.add(1);
         
        }
      }
      for (var i = 0; i < ap.length; i++) {
        DateTime dt = ap[i]['end time'].toDate();
        
        DateTime dateS = ap[i]['start time'].toDate();
        bool validDatee = dateS.isBefore(et);
        
        if (validDatee == true) {
         
          conflictAppt.add(1);
          
        } else {
          
        }
      }
      if (conflictAppt.length > 0) {
      
        return true;
      }

      return false;
    }
  }

  Future bookAppt(uid1, collection, uid2, field, st, et, token, token2,name1,name2,image1,image2) async {
    User user = auth.currentUser;
    List pe = [];
    var check = await checkAp(field, uid2, st, et);
   
    String x = st.toString() + et.toString();
    await FirebaseFirestore.instance
        .collection('Appt')
        .doc(auth.currentUser.uid + uid2 + x)
        .set({
      'start time': Timestamp.fromDate(st),
      'end time': Timestamp.fromDate(et),
      'state': 'pending',
      'coll': collection,
      'id1': auth.currentUser.uid,
      'id2': uid2,
      'id': auth.currentUser.uid + uid2 + x,
      'token': token,
      'SecToken': token2,
      'name1': name1,
      'name2':name2,
      'image1':image1,
      'image2':image2,
    });
    
  }
}

class DatabaseAppt {
  Future getMyAppt(uid) async {
    List appts = [];
    List coll = [
      'Plumber',
      'Personal Trainer',
      'Electrician',
      'Data Scientist',
      'Software Engineer',
      'Civil Engineers',
      'Nutritionist',
      'PE',
      'Handyman',
      'Architect',
      'Electrician',
      'Carpenter',
      'Interior Designer',
      'BlackSmith',
      'Industrial Engineer'
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

  Future getExpAppt(uid, type) async {
    List appts = [];
    /*for (var col in coll) {
      Query colcollectionReference = await FirebaseFirestore.instance
          .collection(col)
          .doc(uid)
          .collection('appt');*/
    Query colcollectionReference = await FirebaseFirestore.instance
        .collection('Appt')
        .where('id1', isEqualTo: uid)
        .where('state', isEqualTo: "Accepted");
    Query colcollectionReference2 = await FirebaseFirestore.instance
        .collection('Appt')
        .where('id2', isEqualTo: uid)
        .where('state', isEqualTo: "Accepted");
    try {
      await colcollectionReference.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          appts.add(element.data());
        });
      });
      await colcollectionReference2.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          appts.add(element.data());
        });
      });
    } catch (e) {
      print(e.toString());
    }
    return appts;
  }

  Future getAppt(uid, type) async {
    List appts = [];
    Query colcollectionReference = await FirebaseFirestore.instance
        .collection('Appt')
        .where('id1', isEqualTo: auth.currentUser.uid)
        .where('state', isEqualTo: "Accepted");
    
    Query colcollectionReference2 = await FirebaseFirestore.instance
        .collection('Appt')
        .where('id2', isEqualTo: auth.currentUser.uid)
        .where('state', isEqualTo: "Accepted");
   
    try {
      await colcollectionReference.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          if (element.data()['end time'].toDate().isAfter(DateTime.now())) {
            appts.add(element.data());
          }
        });
      });
      await colcollectionReference2.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          if (element.data()['end time'].toDate().isAfter(DateTime.now())) {
            appts.add(element.data());
          }
        });
      });
    } catch (e) {
      print(e.toString());
    }
    return appts;
  }
}

class DataBaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future getCurrentUSerData(id, collection) async {
    List coll = [
      'Plumber',
      'Personal Trainer',
      'Electrician',
      'Data Scientist',
      'Software Engineer',
      'Civil Engineer',
      'Nutritionis',
    ];
    User user = auth.currentUser;
    List profile = [];
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      profile.add(documentSnapshot.data());
    });
    return profile;
  }
}
