// import 'package:flutter/material.dart';

class Events {
  static List<Events> unsortedEventsList = [];
  static List<Events> eventsList = [];
  final String title;
  final int year;
  final int month;
  final int date;
  final int hour;
  final int minute;

  Events({
    required this.title,
    required this.year,
    required this.month,
    required this.date,
    required this.hour,
    required this.minute,
  }) {
    // eventsList.add({
    //   'title': title,
    //   'year': year,
    //   'date': date,
    //   'hour': hour,
    //   'minute': minute,
    // });
  }
}
