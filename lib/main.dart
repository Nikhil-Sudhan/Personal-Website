import 'package:flutter/material.dart';
import 'package:nicky/bottombutton.dart';
import 'package:nicky/home.dart';
import 'package:nicky/topbutton.dart';
import 'package:nicky/wallpapaer.dart';

// Custom ScrollPhysics to disable upward scrolling once moved to the second page
class NoBackScrollPhysics extends ScrollPhysics {
  const NoBackScrollPhysics({super.parent});

  @override
  NoBackScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return NoBackScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) {
    // Allow scrolling down when not at the bottom
    if (position.pixels == position.minScrollExtent) {
      return true;
    }

    // Prevent scrolling up when not at the top
    if (position.pixels == position.maxScrollExtent) {
      return false;
    }

    return super.shouldAcceptUserOffset(position);
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (offset > 0) {
      // Allow scrolling down
      return offset;
    } else if (position.pixels <= position.minScrollExtent && offset < 0) {
      // Prevent scrolling up if at the top of the list (first page)
      return 0;
    }

    return super.applyPhysicsToUserOffset(position, offset);
  }
}

void main() => runApp(const Lock());

class Lock extends StatefulWidget {
  const Lock({super.key});

  @override
  State<Lock> createState() => _LockState();
}

class _LockState extends State<Lock> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 42),
          child: Center(
            child: SizedBox(
              width: 375,
              child: Topbutton(),
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = MediaQuery.of(context).size.height;
            const appBarHeight = 42.0;
            const bottomBarHeight = 60.0;

            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: SizedBox(
                      width: 375,
                      height: availableHeight - appBarHeight - bottomBarHeight,
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
                            child: const Wallpapaer(),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A0A0A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const LumiaUI(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: 375,
                    child: Container(
                      color: Colors.black,
                      child: Bottom(
                        onBack: () {
                          // If on home page (index 1), go back to lockscreen (index 0)
                          // If on lockscreen (index 0), stay on lockscreen
                          if (_pageController.hasClients) {
                            if (_pageController.page == 1) {
                              _pageController.animateToPage(
                                0,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          }
                        },
                        onHome: () {
                          // Always navigate to home page (index 1)
                          if (_pageController.hasClients) {
                            _pageController.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
