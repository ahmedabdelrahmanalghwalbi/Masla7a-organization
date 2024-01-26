import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class Schedual extends StatefulWidget {
  @override
  _SchedualState createState() => _SchedualState();
}

class _SchedualState extends State<Schedual> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      initialSelectedDate: DateTime.now(),
//      dataSource: DataSuorce(),
    );
  }
}


