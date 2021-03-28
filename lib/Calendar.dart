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
      drawer: NavDrawer(type: "Expert",),
      appBar: AppBar(
          title: Text("Calendar"),
          elevation: .1,
          backgroundColor: Color(0xff5848CF)),
      body: SfCalendar(

        view: CalendarView.week,
        firstDayOfWeek: 1,
        timeSlotViewSettings: TimeSlotViewSettings(endHour: 24,startHour: 8,minimumAppointmentDuration: Duration(minutes: 30),timeIntervalHeight: 80),
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
             Duration(hours: 1)),
         subject: 'Meeting',
         color: Colors.blue,
         startTimeZone: '',
         endTimeZone: ''
       ));

  return DataSource(appointments);
}