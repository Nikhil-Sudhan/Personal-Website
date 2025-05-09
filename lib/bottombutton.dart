import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  const Bottom({super.key});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 425,
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/download_removebg_preview_191.png',
                width: 43,
                height: 36,
                fit: BoxFit.contain,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/windows-10.png',
                width: 43,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/download_removebg_preview_201.png',
              width: 28,
              height: 28,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
