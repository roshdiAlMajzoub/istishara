import 'dart:convert';
import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/ProfileView.dart';
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
  Future updateuserData(fname, lname, pnumber, email) async {
    return await collectionReference.doc(uid).set({
      'first name': fname,
      'last name': lname,
      'email': email,
      'phone number': pnumber,
      'id': uid,
    });
  }
}

class DataBaseServiceExperts {
  final String uid;
  DataBaseServiceExperts({this.uid});
  Future updateuserData(fname, lname, pnumber, email, exp, cvN) async {
    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection(exp);

    return await collectionReference.doc(uid).set({
      'first name': fname,
      'last name': lname,
      'email': email,
      'phone number': pnumber,
      'reputation': 0,
      'id': uid,
      'CV name': cvN,
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
        .where('id2',isEqualTo: auth.currentUser.uid)
        .where('state', isEqualTo: "pending");
    /*Query colcollectionReference = FirebaseFirestore.instance
        .collection(coll)
        .doc(auth.currentUser.uid)
        .collection('appt')
        .where('state', isEqualTo: "pending");*/
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
        .collection('Appt')
        .where('id2', isEqualTo: userid)
        //.where('start time', isGreaterThanOrEqualTo: Timestamp.fromDate(st))
        //.where('start time', isLessThanOrEqualTo: Timestamp.fromDate(et))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if ((element.data()['start time'].toDate().isAfter(st)) || (element.data()['start time'].toDate()==(st)) || ((element.data()['start time'].toDate().isBefore(st))&&(element.data()['end time'].toDate().isAfter(st)) )) {
          ap.add(element.data());
        }
      });
    });
    var b = await FirebaseFirestore.instance
        .collection('Appt')
        .where('id2', isEqualTo: userid)
        //.where('end time', isGreaterThanOrEqualTo: Timestamp.fromDate(st))
        //.where('start time', isLessThanOrEqualTo: Timestamp.fromDate(et))
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        if ((element.data()['end time'].toDate().isAfter(st)) ||  (element.data()['end time'].toDate()==(st))){
          app.add(element.data());
        }
      });
    });
    /* var a = await FirebaseFirestore.instance
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
    });*/

    if (ap.length == 0 && app.length == 0) {
      return false;
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
        print("there is conflict");
        return true;
      }

      return false;
    }
  }

  Future bookAppt(uid1, collection, uid2, field, st, et,token,token2) async {
    List coll = [
      'Plumber',
      'Personal Trainer',
      'Electrician',
      'Data Scientist',
      'Software Engineer'
    ];
    User user = auth.currentUser;
    List pe = [];
    var check = await checkAp(field, uid2, st, et);
    //print(check);
    // ignore: unrelated_type_equality_checks
    String x = st.toString() + et.toString();
    await FirebaseFirestore.instance.collection('Appt').doc(auth.currentUser.uid+uid2+x).set({
      'start time': Timestamp.fromDate(st),
      'end time': Timestamp.fromDate(et),
      'state': 'pending',
      'coll': collection,
      'id1': auth.currentUser.uid,
      'id2': uid2,
      'id': auth.currentUser.uid+uid2+x,
      'token':token,
      'SecToken': token2
    });
    /*await FirebaseFirestore.instance
        .collection(field)
        .doc(uid2)
        .collection('appt')
        .doc(x)
        .set({
      'start time': Timestamp.fromDate(st),
      'end time': Timestamp.fromDate(et),
      'state': 'pending',
      'coll': collection,
      'id': auth.currentUser.uid,
      'uid':x,
    });*/

    /* for (var col in coll) {
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
            'state': 'pending'
          });

          print(col + " document exist");
        }
      });
    }*/
    print(pe);
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
    /*for (var col in coll) {
      Query colcollectionReference = await FirebaseFirestore.instance
          .collection(col)
          .doc(uid)
          .collection('appt');*/
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
    /*Query colcollectionReference = await FirebaseFirestore.instance
        .collection(type)
        .doc(uid)
        .collection('appt')
        .where('state', isEqualTo: "Accepted");
    try {
      await colcollectionReference.get().then((QuerySnapshot) {
        QuerySnapshot.docs.forEach((element) {
          appts.add(element.data());
        });
      });
    } catch (e) {
      print(e.toString());
    }
    return appts;*/
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
    print(auth.currentUser.uid);
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      profile.add(documentSnapshot.data());
    });
    /* for (var col in coll) {
      await FirebaseFirestore.instance
          .collection(col)
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          profile.add(documentSnapshot.data());
        }
      });
    }*/
    return profile;
  }
/*         notification functionsss
  String constructFCMPayload() {
    final fcm.FirebaseMessaging f = fcm.FirebaseMessaging.instance;
    return jsonEncode({
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification () was created via FCM!',
      },
      'to':
          "ds-tqusgTrWsBL5KBC5IgW:APA91bEgwHI-aJ2srZJFFFaS4OIIULOsd_tcJemVke4zgaCkFvz3nfk00nWiHC-QT6RzEsebOYh4Z3Zkc5tNcPYOdtqZUjQGbWDKLhIF6CPrtVj431alg3nG2HmLbWLMZ0M3JQ15ziQN",
      // "fmClhZ2GTkW4CO8vyYpZ0h:APA91bF7lY7DsHfapW-MRAzo3jSBAzukuGsmZvuycXSACokke3KiwXYDbXI1FOb2pTSsgXDWXG5qVxGtaeXUnTnzG5m9vLwfj0rSchARVltSsim4oQrozewQnEXIO9nvo8ocS1fbGiM6",
    });
  }

  var postUrl = "https://fcm.googleapis.com/fcm/send";
  Future<void> sendNotification(receiver, msg) async {
    var token = "fmClhZ2GTkW4CO8vyYpZ0h:APA91bF7lY7DsHfapW-MRAzo3jSBAzukuGsmZvuycXSACokke3KiwXYDbXI1FOb2pTSsgXDWXG5qVxGtaeXUnTnzG5m9vLwfj0rSchARVltSsim4oQrozewQnEXIO9nvo8ocS1fbGiM6";
    final data = jsonEncode({
      "notification": {
        "body": "Accept Ride Request",
        "title": "This is Ride Request"
      },
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done"
      },
      "to":
          "fmClhZ2GTkW4CO8vyYpZ0h:APA91bF7lY7DsHfapW-MRAzo3jSBAzukuGsmZvuycXSACokke3KiwXYDbXI1FOb2pTSsgXDWXG5qVxGtaeXUnTnzG5m9vLwfj0rSchARVltSsim4oQrozewQnEXIO9nvo8ocS1fbGiM6",
    });
    /*final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=AIzaSyCItpDq0vPOViSA5VsOL8vWFZ-hQKnWIok'
    };
    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );*/
    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          "Content-Type": 'application/json',
          "Authorization": 'key=AIzaSyCItpDq0vPOViSA5VsOL8vWFZ-hQKnWIok'
        },
        body: jsonEncode({
            "token": token,
            "data": {
              "via": 'FlutterFire Cloud Messaging!!!',
              "count": '2',
            },
            "notification": {
              "title": 'Hello FlutterFire!',
              "body": 'This notification 4 was created via FCM!',
            },
      }),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }

    /*try {
          final response = await Dio(options).post("https://fcm.googleapis.com/fcm/send",
              data: data);

          if (response.statusCode == 200) {
            Fluttertoast.showToast(msg: 'Request Sent To Driver');
          } else {
            print('notification sending failed');
            // on failure do sth
          }
        }catch(e){
          print(e.message);
        }*/
  }
*/

}
