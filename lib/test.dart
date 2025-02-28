import 'package:flutter/material.dart';
import 'package:nicky/bottombutton.dart';
import 'package:nicky/home.dart';
import 'package:nicky/topbutton.dart';
import 'package:nicky/wallpapaer.dart';
import 'dart:async';


void main() => runApp(const Lock());

class Lock extends StatefulWidget {
  const Lock({super.key});

  @override
  State<Lock> createState() => _LockState();
}

class _LockState extends State<Lock> {
  final PageController _pageController = PageController();
  bool _isLocked = false;
  bool _showPasswordPrompt = false;
  bool _loading = false;
  String? _selectedFile;
  bool _fileOpened = false;
  final List<String> _files = ["File 1", "File 2", "File 3"];
  final String _correctPassword = "qwerty";
  String _enteredPassword = '';
  Timer? _longPressTimer;

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  void _onPowerButtonTap() {
    setState(() {
      _isLocked = !_isLocked;
    });
  }

  void _onPowerButtonLongPress() {
    _longPressTimer = Timer(const Duration(seconds: 10), () {
      setState(() {
        _showPasswordPrompt = true;
      });
    });
  }

  void _onPasswordEntered(String value) {
    setState(() {
      _enteredPassword = value;
    });

    if (_enteredPassword == _correctPassword) {
      setState(() {
        _loading = true;
      });

      // Simulate loading after entering password
      Future.delayed(const Duration(seconds: 3), () {
        setState(() {
          _loading = false;
          _showPasswordPrompt = false;
          _isLocked = false; // Unlock the phone
        });
      });
    }
  }

  void _openFile(String? file) {
    setState(() {
      _selectedFile = file;
      _fileOpened = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 42), // Set height only
          child: Center(
            child: SizedBox(
              width: 425,
              child: Topbutton(),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Center(
                  child: SizedBox(
                    width: 425,
                    height: 740,
                    child: PageView(
                      controller: _pageController,
                      scrollDirection: Axis.vertical,
                      physics: const NoBackScrollPhysics(),
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0A0A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: _isLocked
                              ? const Center(
                                  child: Text(
                                    "Locked",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 24),
                                  ),
                                )
                              : const Wallpapaer(), // First page
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF0A0A0A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const LumiaUI(), // Second page
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 425,
                    height: 60, // Set desired height for the container
                    color: const Color.fromARGB(255, 255, 255,
                        255), // Set background color for the container
                    child: const Center(child: Bottom()),
                  ),
                ),
              ],
            ),
            // Power button outside the phone UI on the right side
            Positioned(
              right: 20,
              top: 100,
              child: GestureDetector(
                onTap: _onPowerButtonTap,
                onLongPress: _onPowerButtonLongPress,
                onLongPressUp: () {
                  _longPressTimer?.cancel();
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            // Show password prompt if required
            if (_showPasswordPrompt)
              Center(
                child: _loading
                    ? const CircularProgressIndicator()
                    : Container(
                        color: Colors.black,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Enter Password:',
                              style: TextStyle(
                                  color: Colors.greenAccent, fontSize: 18),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              style: const TextStyle(color: Colors.greenAccent),
                              obscureText: true,
                              onChanged: _onPasswordEntered,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                fillColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            // Show file list and dropdown after unlocking
            if (!_loading &&
                !_showPasswordPrompt &&
                _selectedFile == null &&
                !_isLocked)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Secret Files",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: _selectedFile,
                      hint: const Text(
                        "Select a File",
                        style: TextStyle(color: Colors.white),
                      ),
                      dropdownColor: Colors.black,
                      items: _files.map((file) {
                        return DropdownMenuItem<String>(
                          value: file,
                          child: Text(file,
                              style: const TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: _openFile,
                    ),
                  ],
                ),
              ),
            // Show file content after selecting a file
            if (_fileOpened)
              Center(
                child: Container(
                  color: Colors.black,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "File Content of $_selectedFile",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "This is the secret content of the file.",
                        style:
                            TextStyle(color: Colors.greenAccent, fontSize: 16),
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

class NoBackScrollPhysics extends ScrollPhysics {
  const NoBackScrollPhysics({super.parent});

  @override
  NoBackScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NoBackScrollPhysics(parent: buildParent(ancestor));
  }
}
