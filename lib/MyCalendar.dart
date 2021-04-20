import 'dart:async';

import 'package:ISTISHARA/Chat/ChatScreen.dart';
import 'package:ISTISHARA/Chat/Conversations.dart';
import 'package:ISTISHARA/Database.dart';
import 'package:ISTISHARA/Databasers.dart';
import 'package:ISTISHARA/Helper.dart';
import 'package:ISTISHARA/ShowDialog.dart';
import 'package:ISTISHARA/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'nav-drawer.dart';
import 'package:ISTISHARA/Time.dart';
import 'package:intl/intl.dart';

class MainCalendar extends StatelessWidget {
  var id;
  var collection;
  MainCalendar(id) {
    this.id = id;
    this.collection = collection;
  }
  @override
  Widget build(BuildContext context) {
    return MyCalendar(id, collection);
  }
}

Databasers databasers = Databasers();

class MyCalendar extends StatefulWidget {
  var id;
  var collection;
  MyCalendar(id, collection) {
    this.id = id;
    this.collection = collection;
  }
  @override
  CalendarState createState() => CalendarState(id, collection);
}

class CalendarState extends State<MyCalendar> {
  var id;
  var collection;
  bool _isLoading = false;

  CalendarState(id, collection) {
    this.id = id;
    this.collection = collection;
  }
  final FirebaseAuth auth = FirebaseAuth.instance;

  List apptt = [];
  fetchDatabaseAppt() async {
    final User user = auth.currentUser;
    dynamic resultant = await DatabaseAppt().getAppt(id, collection) as List;
    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        apptt = resultant;
      });
    }
  }

  String getStartTimeFromCalendar(Meeting appointmentDetails) {
    return DateFormat('HH:mm').format(appointmentDetails.from).toString();
  }

  String getEndTimeFromCalendar(Meeting appointmentDetails) {
    return DateFormat('HH:mm').format(appointmentDetails.to).toString();
  }

  String getEndTimeFromFirebase(int i) {
    return apptt[i]['end time'].toDate().toString().substring(11);
  }

  String getStartTimeFromFirebase(int i) {
    return apptt[i]['start time'].toDate().toString().substring(11);
  }

  String getDateFromFireBase(int i) {
    return apptt[i]['end time'].toDate().toString().substring(0, 10);
  }

  Future<String> getIDOfTheOther(int i) async {
    String IDofTheOther;
    String collectionOfTheOther;
    String myID = FirebaseAuth.instance.currentUser.uid;
    if (myID != apptt[i]['id2']) {
      collectionOfTheOther = await databasers.docExistsIn(apptt[i]['id2']);
      IDofTheOther = apptt[i]['id2'];
    } else {
      collectionOfTheOther = await databasers.docExistsIn(apptt[i]['id1']);
      IDofTheOther = apptt[i]['id1'];
    }
    return IDofTheOther;
  }

  Future<String> getNameOfTheOther(int i) async {
    String IDofTheOther;
    String name = "";
    String collectionOfTheOther;
    String myID = FirebaseAuth.instance.currentUser.uid;
    if (myID != apptt[i]['id2']) {
      collectionOfTheOther = await databasers.docExistsIn(apptt[i]['id2']);
      IDofTheOther = apptt[i]['id2'];
    } else {
      collectionOfTheOther = await databasers.docExistsIn(apptt[i]['id1']);
      IDofTheOther = apptt[i]['id1'];
    }
    Query colcollectionReference =
        FirebaseFirestore.instance.collection(collectionOfTheOther);
    await colcollectionReference.get().then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((element) {
        if (element.get('id') == IDofTheOther) {
          name = element.get('first name') + " " + element.get('last name');
        }
      });
    });

    return name;
  }

  Future<String> getImageOfTheOther(int i) async {
    String imageOfTheOther = "";
    String myID = FirebaseAuth.instance.currentUser.uid;
    String IDofTheOther;
    String collectionOfTheOther;
    if (myID != apptt[i]['id2']) {
      collectionOfTheOther = await databasers.docExistsIn(apptt[i]['id2']);
      IDofTheOther = apptt[i]['id2'];
    } else {
      collectionOfTheOther = await databasers.docExistsIn(apptt[i]['id1']);
      IDofTheOther = apptt[i]['id1'];
    }
    Query colcollectionReference =
        FirebaseFirestore.instance.collection(collectionOfTheOther);
    await colcollectionReference.get().then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((element) {
        String myId = FirebaseAuth.instance.currentUser.uid;
        if (element.get('id') == IDofTheOther) {
          imageOfTheOther = element.get('image name');
        }
      });
    });

    var img = await Databasers().downloadLink(FirebaseStorage.instance
        .ref()
        .child('playground')
        .child(imageOfTheOther));

    return img;
  }

  Future<String> getImageOfMe(int i) async {
    String imageOfMe;
    String myID = FirebaseAuth.instance.currentUser.uid;
    Query colcollectionReference =
        FirebaseFirestore.instance.collection(widget.collection);
    await colcollectionReference.get().then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((element) {
        if (element.get('id') == myID) {
          imageOfMe = element.get('image name');
        }
      });
    });

    var img = await Databasers().downloadLink(
        FirebaseStorage.instance.ref().child('playground').child(imageOfMe));

    return img;
  }

  /*book() {
    final User user = auth.currentUser;
    DatabaseBookAppt().bookAppt(user.uid, 'uid2', DateTime.now(),
        DateTime.now().add(Duration(hours: 2)));
  }*/
  List<Meeting> meetings = <Meeting>[];
  @override
  Widget build(BuildContext context) {
    _getData();
    return Scaffold(
        drawer: NavDrawer(
          type: "hey",
          collection: collection,
        ),
        appBar: AppBar(
            title: Text("Calendar"),
            elevation: .1,
            backgroundColor: Color(0xff5848CF)),
        body: Stack(children: [
          if (_isLoading)
            Align(
              alignment: Alignment(0, 0),
              child: CircularProgressIndicator(),
            ),
          if (!_isLoading)
            SfCalendar(
                timeSlotViewSettings: TimeSlotViewSettings(
                    // endHour: 24,
                    // startHour: 8,
                    minimumAppointmentDuration: Duration(minutes: 15),
                    timeIntervalHeight: 80),
                view: CalendarView.week,
                firstDayOfWeek: 1,
                dataSource: MeetingDataSource(meetings),
                onTap: (details) async {
                  if (details.appointments != null) {
                    if (details.targetElement == CalendarElement.appointment) {
                      final Meeting appointmentDetails =
                          details.appointments[0];
                      String _startTimeText =
                          getStartTimeFromCalendar(appointmentDetails);
                      String date_from_calendar = appointmentDetails.date;
                      String _endTimeText =
                          getEndTimeFromCalendar(appointmentDetails);
                      print(appointmentDetails.from.toString());
                      for (int i = 0; i < apptt.length; i++) {
                        String startTimeFromFirebase =
                            getStartTimeFromFirebase(i);
                        String EndTimeFromFirebase = getEndTimeFromFirebase(i);
                        String startTimeFromCalendar =
                            _startTimeText + ":00.000";
                        String EndTimeFromCalendar = _endTimeText + ":00.000";
                        String date_from_Firebase = getDateFromFireBase(i);

                        if ((DateTime.now()
                                .isAfter(apptt[i]['start time'].toDate()) ||
                            DateTime.now().isAtSameMomentAs(
                                apptt[i]['start time'].toDate()))&&(apptt[i]['start time'].toDate() == appointmentDetails.from)) {
                          setState(() {
                            _isLoading = true;
                          });
                          print("I am in if");
                          String imageOfTheOther = await getImageOfTheOther(i);
                          String nameOfTheOther = await getNameOfTheOther(i);
                          String IDofTheOther = await getIDOfTheOther(i);
                          String myImage = await getImageOfMe(i);
                          String myName =
                              FirebaseAuth.instance.currentUser.displayName;
                          String id1 = FirebaseAuth.instance.currentUser.uid;
                          _isLoading = false;
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatScreen(
                                id1: id1,
                                image: imageOfTheOther,
                                name: nameOfTheOther,
                                id: apptt[i]['id'],
                                endtime: apptt[i]['end time'],
                                isConversation: false,);
                          }));
                          break;
                        } else if (startTimeFromFirebase ==
                                startTimeFromCalendar &&
                            EndTimeFromCalendar == EndTimeFromFirebase &&
                            date_from_calendar == date_from_Firebase) {
                          String name = await getNameOfTheOther(i);

                          Show.showDialogMeetingDetails(
                              context,
                              "Meeting with " + name,
                              apptt[i]['start time'].toDate().toString(),
                              _endTimeText,
                              date_from_Firebase);
                          break;
                        }
                      }
                    }
                  }
                }),
        ]));
  }

  getConflictappt() async {
    final User user = auth.currentUser;
    dynamic bool = await DatabaseBookAppt().checkAp(
        'Electrician',
        user.uid,
        DateTime.now().add(Duration(hours: 1, minutes: 5)),
        DateTime.now().add(Duration(hours: 3)));
    print(bool);
  }

  void _getData() async {
    final User user = auth.currentUser;
    //getConflictappt();
    //print(DateTime.now());

    fetchDatabaseAppt();
    for (var ap in apptt) {
      DateTime st = ap['start time'].toDate();
      DateTime et = ap['end time'].toDate();
      String date = ap['end time'].toDate().toString().substring(0, 10);
      String id = ap['id'];

      meetings.add(Meeting('Appt', st, et, Color(0xFF0F8644), false, date, id));
    }
  }
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  DateTime getID(int index) {
    return appointments[index].id;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay,
      this.date, this.id);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  String date;

  String id;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}

/*
class DataSource extends CalendarDataSource {
  DataSource(List<Appointment> source) {
    appointments = source;
  }
}

DataSource _getCalendarDataSource() {
  List<Appointment> appointments = <Appointment>[];
  final DateTime today = DateTime.now();
  final DateTime startTime =
      DateTime(today.year, today.month, today.day, 9, 0, 0);
  final DateTime endTime = startTime.add(const Duration(hours: 2));
  final DateTime st = startTime.add(const Duration(hours: 2));
  final DateTime et = startTime.add(const Duration(hours: 4));
  Appointment app = Appointment('rosh', st, et, const Color(0xFF0F8644), true);
  appointments.add(app);
  appointments.add(
    Appointment(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false),
    /*startTime: DateTime.now(),
         endTime: DateTime.now().add(
             Duration(hours: 1)),
         subject: 'Meeting',
         color: Colors.blue,
         startTimeZone: '',
         endTimeZone: '',*/
  );

  return DataSource(appointments);
}

class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Appointment {
  /// Creates a meeting class with required details.
  Appointment(
      this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
*/