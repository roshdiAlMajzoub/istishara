import 'package:ISTISHARA/ViewCalendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

// ...

DateTime selected;
DateTime start;

class BasicDateField extends StatelessWidget {
  final String title;
  GlobalKey<FormState> dateKey;
  var dateControl;
  BasicDateField(
      {@required this.title,
      @required this.dateControl,
      @required this.dateKey});
  final format = DateFormat("yyyy-MM-dd");
  @override
  Widget build(BuildContext context) {
    return Form(
        key: dateKey,
        child: DateTimeField(
          onChanged: (value) {
            selected = value;
            print(dateControl.value.text);
          },
          validator: (DateTime value) {
            DateTime thresh = DateTime.now().add(Duration(days: 7));
            if (value == null) {
              return "Please Select a date";
            } else if (value.isAfter(thresh)) {
              return "Appointment should be within a week";
            } else if (value.day < DateTime.now().day) {
              return "Do you live in the past?";
            } else {
              print(selected.toString());
              return null;
            }
          },
          controller: dateControl,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: title),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          format: format,
          onShowPicker: (context, currentValue) {
            dateKey.currentState.reset();
            return showDatePicker(
                context: context,
                firstDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),
                initialDate: currentValue ?? DateTime.now(),
                lastDate:DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day+7),);
          },
        ));
  }
}

class BasicTimeField extends StatelessWidget {
  final String title;
  GlobalKey<FormState> timeKey;
  var timeControl;
  BasicTimeField(
      {@required this.title, @required this.timeControl, this.timeKey});
  final format = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Form(
        key: timeKey,
        child: DateTimeField(
          onChanged: (value) {
            if (title == "Choose Start Time")
              start = value;
            else {}
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              labelText: title),
          controller: timeControl,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
          format: format,
          validator: (DateTime value) {
            if (title == "Choose Start Time") {
              if (value == null) {
                return "Please Choose Start Time";
              } else if (selected.day == DateTime.now().day &&
                  ((value.hour < DateTime.now().hour) ||
                      (value.minute < DateTime.now().minute + 10 &&
                          value.hour == DateTime.now().hour))) {
                print(value.toString());
                return "Invalid Time";
              } else {
                return null;
              }
            } else {
              if (value == null) {
                return "Please Choose End Time";
              } else if (value.hour < start.hour) {
                return "Start and End Time Overlap";
              } else if (value.minute < start.minute + 10) {
                return "Consultation can not be at least 10 minutes";
              } else {
                return null;
              }
            }
          },
          onShowPicker: (context, currentValue) async {
            timeKey.currentState.reset();
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.convert(time);
          },
        ));
  }
}
