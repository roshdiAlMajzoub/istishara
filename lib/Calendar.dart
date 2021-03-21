import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'nav-drawer.dart';

class MainCalendar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Calendar();
  }
}

class Calendar extends StatefulWidget {
  @override
  CalendarState createState() => CalendarState();
}

class CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
          title: Text("Calendar"),
          elevation: .1,
          backgroundColor: Color(0xff5848CF)),
      body: SfCalendar(
        view: CalendarView.week,
        firstDayOfWeek: 6,
        dataSource: _getCalendarDataSource(),
      ),
    );
  }
}

class DataSource extends CalendarDataSource {
 DataSource(List<Appointment> source) {
   appointments = source;
 }
}

DataSource _getCalendarDataSource() {
   List<Appointment> appointments = <Appointment>[];
   appointments.add(
       Appointment(
         startTime: DateTime.now(),
         endTime: DateTime.now().add(
             Duration(hours: 2)),
         isAllDay: true,
         subject: 'Meeting',
         color: Colors.blue,
         startTimeZone: '',
         endTimeZone: ''
       ));

  return DataSource(appointments);
}