// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:nicky/aboutme/first.dart';
import 'package:url_launcher/url_launcher.dart';

import 'aboutme/getintouch.dart'; // For launching URLs

class LumiaUI extends StatelessWidget {
  const LumiaUI({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.custom(
            gridDelegate: SliverQuiltedGridDelegate(
              crossAxisCount: 4, // 4 columns
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              pattern: [
                const QuiltedGridTile(1, 1), // call
                const QuiltedGridTile(1, 1), // message
                const QuiltedGridTile(1, 2), // name
                const QuiltedGridTile(2, 2), // github
                const QuiltedGridTile(1, 1), // music
                const QuiltedGridTile(1, 1), // insta
                const QuiltedGridTile(1, 1), // chrome
                const QuiltedGridTile(1, 1), //x
                const QuiltedGridTile(2, 4), //drone

                const QuiltedGridTile(2, 2), // resume
                const QuiltedGridTile(1, 1), // yt
                const QuiltedGridTile(1, 1), // photos
                const QuiltedGridTile(2, 2), //linkend

                const QuiltedGridTile(1, 2), // flappy

                const QuiltedGridTile(2, 4), //about me
                const QuiltedGridTile(1, 1), //photo of me
                const QuiltedGridTile(1, 1), //whatsapp
                const QuiltedGridTile(1, 2), //get in touch
              ],
            ),
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) => Tile(index: index),
              childCount: 18,
            ),
          ),
        ),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  final int index;
  const Tile({super.key, required this.index});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  bool _isHovered = false;

  final List<Map<String, dynamic>> tiles = [
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'icon': Icons.phone, // Call icon
      'text': '4',
      'fontSize': 30.0,
      'alignment': Alignment.centerRight, // Badge text
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'icon': Icons.message, // Message icon
      'text': '1',
      'fontSize': 30.0,
      'alignment': Alignment.centerRight // Badge text
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'text': 'Nikhl Sudhan J',
      'fontSize': 20.0,
      'alignment': Alignment.bottomLeft // Badge text
    },
    {
      'color': Colors.green[800],
      'hoverColor': Colors.green[900],
      'image': 'assets/images/github.png',
      'url': 'https://github.com/Nikhil-Sudhan',
      //'text': 'GitHub',
      'fontSize': 20.0,
      'alignment': Alignment.bottomLeft,
      'imageSize': 100.0, // Custom image size
      'imageAlignment': Alignment.center,
    },
    {
      'color': Colors.green[800],
      'hoverColor': Colors.green[900],
      'icon': Icons.headphones, // Headphones icon
      'url': 'https://www.spotify.com',
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'image': 'assets/images/insta.png',
      'url': 'https://www.instagram.com',
      'fontSize': 16.0,
      'alignment': Alignment.bottomLeft,
      'imageSize': 55.0, // Custom image size
      'imageAlignment': Alignment.center,
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'image': 'assets/images/chrome.png', // Chrome icon
      'url': 'https://www.google.com/',
      'fontSize': 16.0,
      'alignment': Alignment.bottomLeft,
      'imageSize': 75.0, // Custom image size
      'imageAlignment': Alignment.center,
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'image': 'assets/images/x.png',
      'url': 'https://x.com/Nikhil_Sudhan_J',
      'imageSize': 55.0, // Custom image size
      'imageAlignment': Alignment.center,
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'text': 'Aerial Systems',
      'image': 'assets/images/drone.png',
      'url': 'https://redstar-seven.vercel.app/',
      'fontSize': 26.0,
      'alignment': Alignment.bottomLeft,
      'imageSize': 180,
      'imageColor': Colors.black, // Custom image size
      'imageAlignment': Alignment.topRight,
    },
    {
      'color': Colors.redAccent[700],
      'hoverColor': Colors.red[900],
      'image': 'assets/images/resume.png',
      'text': 'Resume',
      'fontSize': 18.0,
      'alignment': Alignment.topCenter,
      'imageSize': 200.0, // Custom image size
      'imageAlignment': Alignment.bottomCenter,
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'image': 'assets/images/youtube.png',
      'fontSize': 16.0,
      'alignment': Alignment.bottomLeft,
      'url': 'https://www.youtube.com/@CuddleCoder',
      'imageSize': 60.0, // Custom image size
      'imageAlignment': Alignment.center,
    },
    {
      'color': Colors.green[800],
      'hoverColor': Colors.green[900],
      'image': 'assets/images/gallery.png',
      'fontSize': 16.0,
      'alignment': Alignment.bottomLeft,
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'image': 'assets/images/flappy.jpg',
      'fontSize': 16.0,
      'alignment': Alignment.bottomLeft,
      'imageSize': 455.0,
      'imageAlignment': Alignment.center,
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'text': "Let's \nConnect",
      'image': 'assets/images/link.png',
      'fontSize': 16.0,
      'url': 'https://www.linkedin.com/in/nikhilsudhan',
      'alignment': Alignment.centerRight,
      'imageSize': 55.0,
      'imageAlignment': const Alignment(-0.7, 0), // Move icon slightly to the left
      'padding': const EdgeInsets.only(right: 20), // Add padding
    },
    {
      'color': Colors.green[800],
      'hoverColor': Colors.green[900],
      'text': "About Me",
      'fontSize': 18.0,
      'alignment': Alignment.bottomLeft,
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],

      'image': 'assets/images/dp.jpg',
      'fontSize': 16.0,
      'alignment': Alignment.bottomLeft,
      'imageSize': 85.0, // fit
      'imageAlignment': Alignment.center,
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],

      'image': 'assets/images/whatsapp.png',
      'fontSize': 16.0,
      'alignment': Alignment.bottomLeft,
      'imageSize': 55.0, // Custom image size
      'imageAlignment': Alignment.center,
    },
    {
      'color': Colors.lightBlueAccent[400],
      'hoverColor': Colors.lightBlueAccent[700],
      'text': "Get In Touch!",
      'fontSize': 23.0,
      'alignment': Alignment.bottomLeft,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final tileData = tiles[widget.index % tiles.length];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          if (tileData['url'] != null) {
            _launchURL(tileData['url']);
          } else if (tileData['text'] == 'About Me') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const About()),
            );
          } else if (tileData['text'] == 'Resume') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const About()), // Assuming Resume is a separate page
            );
          } else if (tileData['text'] == 'Get In Touch!') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const Getin()), // Navigate to Getin page
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: _isHovered ? tileData['hoverColor'] : tileData['color'],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Stack(
            children: [
              if (tileData.containsKey('image'))
                Padding(
                  padding: tileData['padding'] ?? EdgeInsets.zero,
                  child: Align(
                    alignment: tileData['imageAlignment'] ?? Alignment.center,
                    child: Image.asset(
                      tileData['image'],
                      width: tileData['imageSize'] ?? 50.0,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              if (tileData.containsKey('icon'))
                Center(
                  child: Icon(
                    tileData['icon'],
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              if (tileData.containsKey('text'))
                Align(
                  alignment: tileData['alignment'], // Set custom text alignment
                  child: Padding(
                    padding: const EdgeInsets.all(8.0), // Add some padding
                    child: Text(
                      tileData['text'],
                      style: TextStyle(
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: tileData['fontSize'], // Set custom font size
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _launchURL(String? url) async {
    if (url != null && await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
