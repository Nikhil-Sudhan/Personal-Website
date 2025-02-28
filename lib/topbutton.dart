import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Topbutton extends StatefulWidget {
  const Topbutton({super.key});

  @override
  State<Topbutton> createState() => _TopbuttonState();
}

class _TopbuttonState extends State<Topbutton> {
  late String _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = _formatCurrentTime(); // Set initial time
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _currentTime = _formatCurrentTime(); // Update time every second
      });
    });
  }

  // Method to get the formatted current time
  String _formatCurrentTime() {
    return DateFormat('HH:mm').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 425,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 0, 0, 0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        border: Border(
          left: BorderSide(
            color: Color(0xFF000000),
          ),
          top: BorderSide(
            color: Color(0xFF000000),
          ),
          right: BorderSide(
            color: Color(0xFF000000),
          ),
          bottom: BorderSide(
            color: Color(0xFF000000),
          ),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(32, 10, 32, 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the updated current time here
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              child: SizedBox(
                width: 33,
                child: Text(
                  _currentTime, // Displays the real-time clock
                  style: const TextStyle(
                    fontFamily: 'Segoe',
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    fontSize: 13, // Set custom font size
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 4, 0, 2),
              child: SizedBox(
                width: 82.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // WiFi icon
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 2.7, 0),
                      width: 21.3,
                      height: 14,
                      child: const Icon(
                        Icons.signal_wifi_4_bar,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    // Signal strength icon
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                      width: 18.7,
                      height: 14,
                      child: const Icon(
                        Icons.signal_cellular_4_bar,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                    // Battery icon
                    SizedBox(
                      width: 32,
                      height: 17,
                      child: Image.asset('assets/images/battery.png'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
