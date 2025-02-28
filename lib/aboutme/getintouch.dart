import 'package:flutter/material.dart';

class Getin extends StatelessWidget {
  const Getin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: Container(
          width: 425,  // Set width
          height: 740, // Set height
          padding: const EdgeInsets.all(16.0),  // Padding around the container
          decoration: BoxDecoration(
            color: Colors.black,
          
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Get in Touch',
                style: TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 30,
          ),
          textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),

              // Intro Text
              Text(
                "I'm always open to collaborate on a project or hear about an opportunity!",
                style: TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 24,
          ),
          textAlign: TextAlign.left, // Change to black
              ),

              SizedBox(height: 46),

              Text(
                "Message me on Social or mail me:",
                style: TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 19,
          ),
          textAlign: TextAlign.left, // Change to black
              ),

              SizedBox(height: 20),

              Text(
                "nikhil.sudhan.jeeva@gmail.com",
                style: TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 19,
          ),
          textAlign: TextAlign.left, // Change to black
              ),


              
              // Add more fields like name, email, message input here as needed
            ],
          ),
        ),
      ),
    );
  }
}
