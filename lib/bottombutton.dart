import 'package:flutter/material.dart';

class Bottom extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onHome;
  const Bottom({super.key, this.onBack, this.onHome});

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 375,
      decoration: const BoxDecoration(
        color: Color(0xFF000000),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: widget.onBack,
            child: Image.asset(
              //back button
              'assets/images/download_removebg_preview_191.png',
              width: 43,
              height: 36,
              fit: BoxFit.contain,
            ),
          ),
          GestureDetector(
            onTap: widget.onHome,
            child: Image.asset(
              //home button
              'assets/images/windows-10.png',
              width: 43,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          Image.asset(
            //search button
            'assets/images/download_removebg_preview_201.png',
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
