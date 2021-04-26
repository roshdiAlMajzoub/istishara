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

   getIDOfTheOther(int i)  {
    String IDofTheOther;
    String myID = FirebaseAuth.instance.currentUser.uid;
    if (myID != apptt[i]['id2']) {
      IDofTheOther = apptt[i]['id2'];
    } else {
      IDofTheOther = apptt[i]['id1'];
    }
    return IDofTheOther;
  }

  

  

  Future getPriceRange(String id) async {
    Databasers db = Databasers();
    var price;
    String collection = await db.docExistsIn(id);
    Query colcollectionReference =
        FirebaseFirestore.instance.collection(collection);
    await colcollectionReference.get().then((QuerySnapshot) {
      QuerySnapshot.docs.forEach((element) {
        if (element.get('id') == id) {
          price = element.get('price range');
        }
      });
    });

    return price;
  }

  


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
                                    apptt[i]['start time'].toDate())) &&
                            (apptt[i]['start time'].toDate() ==
                                appointmentDetails.from)) {
                          setState(() {
                            _isLoading = true;
                          });
                      
                          String imageOfTheOther = "";
                         
                          String IDofTheOther =  getIDOfTheOther(i);
                          String nameOfTheOther = "";
                          if (IDofTheOther == apptt[i]['id1']) {
                            setState(() {
                              imageOfTheOther = apptt[i]['image1'];
                              nameOfTheOther = apptt[i]['name1'];
                            });
                          } else {
                            setState(() {
                              imageOfTheOther = apptt[i]['image2'];
                              nameOfTheOther = apptt[i]['name2'];
                            });
                          }
                          String collection2 =
                              await Databasers().docExistsIn(apptt[i]['id2']);
                      
                          String collection1 =
                              await Databasers().docExistsIn(apptt[i]['id1']);
                          var priceRange = await getPriceRange(apptt[i]['id2']);
                    
                          String id1 = FirebaseAuth.instance.currentUser.uid;
                          _isLoading = false;

                          FirebaseFirestore.instance
                              .collection(
                                  'conversations')
                              .doc(apptt[i]['id'])
                              .update({'started': true});

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ChatScreen(
                              id1: id1,
                              image: imageOfTheOther,
                              name: nameOfTheOther,
                              id: apptt[i]['id'],
                              endtime: apptt[i]['end time'],
                              isConversation: false,
                              collection1: collection1,
                              id2: apptt[i]['id2'],
                              priceRange: priceRange,
                              collection2: collection2,
                              secId1: apptt[i]['id1'],
                            );
                          }));
                          break;
                        } else if (startTimeFromFirebase ==
                                startTimeFromCalendar &&
                            EndTimeFromCalendar == EndTimeFromFirebase &&
                            date_from_calendar == date_from_Firebase) {
                               String IDofTheOther =  getIDOfTheOther(i);
                          String nameOfTheOther = "";
                          if (IDofTheOther == apptt[i]['id1']) {
                            setState(() {
                              nameOfTheOther = apptt[i]['name1'];
                            });
                          } else {
                            setState(() {
                              nameOfTheOther = apptt[i]['name2'];
                            });
                          }
                          Show.showDialogMeetingDetails(
                              context,
                              "Meeting with " + nameOfTheOther,
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
  }

  void _getData() async {
    final User user = auth.currentUser;

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

