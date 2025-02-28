import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';

class Wallpapaer extends StatefulWidget {
  const Wallpapaer({super.key});

  @override
  State<Wallpapaer> createState() => _WallpapaerState();
}

class _WallpapaerState extends State<Wallpapaer> {
  late String _time;
  late String _day;
  late String _month;
  late String _date;

  @override
  void initState() {
    super.initState();
    _updateTimeAndDay(); // Initial call to set the time and day
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _updateTimeAndDay(); // Update the time and day every second
    });
  }

  void _updateTimeAndDay() {
    final now = DateTime.now();
    setState(() {
      _time = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _day = _getDayOfWeek(now.weekday);
      _month = _getMonthName(now.month);
      _date = now.day.toString();
    });
  }

  String _getDayOfWeek(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'January';
      case 2: return 'February';
      case 3: return 'March';
      case 4: return 'April';
      case 5: return 'May';
      case 6: return 'June';
      case 7: return 'July';
      case 8: return 'August';
      case 9: return 'September';
      case 10: return 'October';
      case 11: return 'November';
      case 12: return 'December';
      default: return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/img_111.jpeg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(47, 0, 47, 88),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            '$_time\n\n$_day\n\n$_month\t$_date',
            style: const TextStyle(
              fontFamily: 'Segoe',
              fontWeight: FontWeight.w400,
              fontSize: 42,
              height: 0.5,
              letterSpacing: 0.4,
              color: Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    );
  }
}
