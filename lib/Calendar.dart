import 'package:ISTISHARA/Database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'nav-drawer.dart';

class MainCalendar extends StatelessWidget {
  var id;
  var type;
  var color;
  MainCalendar(id, type, color) {
    this.id = id;
    this.type = type;
    this.color = color;
  }
  @override
  Widget build(BuildContext context) {
    return Calendar(id, type, color);
  }
}

class Calendar extends StatefulWidget {
  var id;
  var type;
  var color;
  Calendar(id, type, color) {
    this.id = id;
    this.type = type;
    this.color = color;
  }
  @override
  CalendarState createState() => CalendarState(id, type, color);
}

class CalendarState extends State<Calendar> {
  var id;
  var type;
  var color;
  CalendarState(id, type, color) {
    this.id = id;
    this.type = type;
    this.color = color;
  }
  final FirebaseAuth auth = FirebaseAuth.instance;

  List apptt = [];
  fetchDatabaseAppt() async {
    final User user = auth.currentUser;
    dynamic resultant = await DatabaseAppt().getAppt(id, type) as List;
    if (resultant == null) {
      print("unable to retrieve");
    } else {
      setState(() {
        apptt = resultant;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(
          type: "",
          collection: type,
        ),
        appBar: AppBar(
            title: Text("Calendar"),
            elevation: .1,
            backgroundColor: Color(0xff5848CF)),
        body: SfCalendar(
          timeSlotViewSettings: TimeSlotViewSettings(
              endHour: 24,
              startHour: 8,
              minimumAppointmentDuration: Duration(minutes: 15),
              timeIntervalHeight: 80),
          view: CalendarView.week,
          firstDayOfWeek: 1,
          dataSource: MeetingDataSource(_getData()),
        ));
    //);
  }

  List<Meeting> _getData() {
    final User user = auth.currentUser;
    fetchDatabaseAppt();
    List meetings = <Meeting>[];
    for (var ap in apptt) {
      DateTime st = ap['start time'].toDate();
      DateTime et = ap['end time'].toDate();

      meetings.add(Meeting('Taken', st, et, color, false));
    }
    return meetings;
  }

  List<Meeting> _getDataSource() {
    List meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime =
        DateTime(today.year, today.month, today.day, 9, 0, 0);
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    meetings.add(Meeting(
        'Conference', startTime, endTime, const Color(0xFF0F8644), false));
    final DateTime st = DateTime(today.year, today.month, today.day, 13, 0, 0);
    final DateTime et = st.add(const Duration(hours: 2));
    Meeting met = Meeting('cmps', st, et, Color(0xFF0F8644), false);
    meetings.add(met);
    return meetings;
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
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

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
