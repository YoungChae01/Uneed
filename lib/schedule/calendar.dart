import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Event {
  final DateTime date;
  Event(this.date);
}

class MyCalendar extends StatelessWidget {
  const MyCalendar({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Calendar_일정'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _now = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];

  final _events = LinkedHashMap<DateTime, DateTime?>(
    equals: isSameDay,
  )..addAll({
    DateTime(2023, 5, 5): DateTime(2023, 5, 5),
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            height: MediaQuery.of(context).size.height * 0.7,
            child: TableCalendar(
              locale: 'ko_KR',
              firstDay: DateTime(_now.year, 1, 1),
              lastDay: DateTime(_now.year, 12, 31),
              focusedDay: _now,
              calendarFormat: _calendarFormat,
              daysOfWeekHeight: 40,
              headerStyle: HeaderStyle(
                titleTextFormatter: (date, locale) =>
                    DateFormat.MMMM(locale).format(date),
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 20.0,
                ),
                headerPadding: const EdgeInsets.symmetric(vertical: 4.0),
                leftChevronIcon: const Icon(
                  Icons.navigate_before,
                  size: 30.0,
                ),
                rightChevronIcon: const Icon(
                  Icons.navigate_next,
                  size: 30.0,
                ),
                leftChevronMargin: const EdgeInsets.only(right: 0.0),
                rightChevronMargin: const EdgeInsets.only(right: 220.0),
              ),
              calendarStyle: const CalendarStyle(
                cellMargin: EdgeInsets.only(bottom: 20.0),
                defaultTextStyle: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                ),
                selectedDecoration: ShapeDecoration(
                  color: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              selectedDayPredicate: (day) {
                // Use `selectedDayPredicate` to determine which day is currently selected.
                // If this returns true, then `day` will be marked as selected.

                // Using `isSameDay` is recommended to disregard
                // the time-part of compared DateTime objects.
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  // Call `setState()` when updating the selected day
                  setState(() {
                    _selectedDay = selectedDay;
                    _now = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  // Call `setState()` when updating calendar format
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                // No need to call `setState()` here
                _now = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                dowBuilder: (context, day) {
                  return Center(
                    child: Text(
                      days[day.weekday],
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  );
                },
                markerBuilder: (context, date, events) {
                  DateTime _date = DateTime(date.year, date.month, date.day);
                  if ( isSameDay(_date, _events[_date] )) {
                    return Container(
                      width: MediaQuery.of(context).size.width * 0.11,
                      padding: const EdgeInsets.only(bottom: 5),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          side: BorderSide(color: Colors.lightBlue, width: 2.0),
                        ),
                      ),
                    );
                  }
                },
              ),
            )
        )
    );
  }
}