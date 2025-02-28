import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late PageController _pageController;

  final List<String> _tabs = ["about me", "experience", "skills", "interests"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Container(
            width: 425,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              color: Color(0xFF0A0A0A),
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "ABOUT ME",
                      style: TextStyle(
                        fontFamily: 'Segoe',
                        fontWeight: FontWeight.w200,
                        color: Colors.white,
                        fontSize: 36,
                      ),
                    ),
                  ),
                  const SizedBox(height: 42),
                  _buildTabBar(),
                  const SizedBox(height: 32),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo is ScrollUpdateNotification) {
                          if (scrollInfo.metrics.axis == Axis.horizontal) {
                            return true;
                          }
                        }
                        return false;
                      },
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          _tabController.index = index;
                        },
                        children: [
                          _buildScrollableContent(const AboutMeContent()),
                          _buildScrollableContent(const ExperienceContent()),
                          _buildScrollableContent(const SkillsContent()),
                          _buildScrollableContent(const InterestsContent()),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: const Color.fromARGB(
          0, 0, 0, 0), // Ensure there's no extra pixel color
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Colors.black, // Set the indicator color to black
        indicatorWeight:
            0.1, // Adjust the thickness of the indicator line if needed
        indicator: const BoxDecoration(
          color: Colors
              .black, // This sets the entire indicator (background) to black
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        labelStyle: const TextStyle(
          fontFamily: 'Segoe',
          fontWeight: FontWeight.w400,
          fontSize: 40,
          height: 0.5,
          letterSpacing: 0.4,
          color: Color(0xFFFFFFFF),
        ),
        indicatorSize: TabBarIndicatorSize.label, // Adjust indicator size
        tabs: List.generate(_tabs.length, (index) {
          return Tab(
            text: _tabs[index].toLowerCase(),
          );
        }),
      ),
    );
  }

  Widget _buildScrollableContent(Widget content) {
    return SingleChildScrollView(
      child: content,
    );
  }
}

// Widget for About Me section
class AboutMeContent extends StatelessWidget {
  const AboutMeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTabContent(
      "Hi, I'm Nikhil Sudhan J",
      "I'm a nature lover and tech enthusiast who spends my days coding and my nights chasing sunsets, savoring snacks, and seeking travel adventures.",
      'assets/images/file.png',
    );
  }
}

// Widget for Experience section
class ExperienceContent extends StatelessWidget {
  const ExperienceContent({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTabContentone(
        "Internship Experience",
        "Wipro, Bangalore",
        "May 28, 2023 - June 30, 2023",
        "Developed a web application, gaining proficiency in deployment techniques. \nGained hands-on experience with Kubernetes, GitOps, and the scaling process.",
        "Sonata Software, Chennai",
        "May 6, 2024 - May 31, 2024",
        "Worked extensively on natural language processing (NLP) and optical character recognition (OCR) technologies.",
        "Startup Initiative",
        "Red Star Aerial Systems",
        "2024 - Present",
        "Founded and currently leading the development of a Minimum Viable Product (MVP).\nOverseeing the growth of a dedicated department focused on innovation and product development.");
  }
}

// Widget for Skill  section
// Widget for Skill section
class SkillsContent extends StatelessWidget {
  const SkillsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildSkillsTabContent();
  }

  Widget _buildSkillsTabContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildExpandableSkillTile(
            "Experiences",
            [
              "Computer Vision",
              "Software Development",
              "Natural Language Processing (NLP)",
              "Drone"
            ],
          ),
          const SizedBox(height: 16),
          _buildExpandableSkillTile(
            "Data Science",
            ["Python with NumPy and Pandas"],
          ),
          const SizedBox(height: 16),
          _buildExpandableSkillTile(
            "Programming Language",
            ["Python", "MATLAB", "SQL", "Flutter"],
          ),
          const SizedBox(height: 16),
          _buildExpandableSkillTile(
            "Development",
            ["Frontend: Flutter, HTML", "Backend: SQL, Firebase"],
          ),
          const SizedBox(height: 16),
          _buildExpandableSkillTile(
            "Operating System",
            ["Linux (Ubuntu, Kali)", "Windows"],
          ),
        ],
      ),
    );
  }
}

// Widget for Interests section
class InterestsContent extends StatelessWidget {
  const InterestsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildTabContent(
      '',
      "I sketch the world around me.\n\nI build and fly drones.\n\nMuhammad Ali inspires me: fighting spirit.\n\nCooking (more Walter White)\n\nCreating AND/OR gates with Arduino boards.",
      '',
    );
  }
}

// Helper function to build the tab content
Widget _buildTabContent(String title, String description, String imagePath) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (imagePath.isNotEmpty) Image.asset(imagePath, height: 500),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 26,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 19,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    ),
  );
}

Widget _buildTabContentone(
    String title,
    String sub,
    String date,
    String description,
    String sub2,
    String date2,
    String description2,
    String title3,
    String sub3,
    String date3,
    String description3) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 32),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Align all text to the left
      children: [
        //const SizedBox(height: 10),
        Align(
          alignment: Alignment.centerLeft, // Align the container to the left
          child: Container(
            width: 700, // Set the width as needed
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'Segoe',
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 23,
              ),
              textAlign: TextAlign
                  .left, // Align the text inside the container to the left
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          sub,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 26,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 9),
        Text(
          date,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 16),
        Text(
          description,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 19,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 16),
        Text(
          sub2,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 26,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 9),
        Text(
          date2,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 16),
        Text(
          description2,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 19,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 18),
        Container(
          width: 700, // Set the width as needed
          margin: const EdgeInsets.all(15.0),
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
          ),
          child: Text(
            title3,
            style: const TextStyle(
              fontFamily: 'Segoe',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 23,
            ),
            textAlign: TextAlign
                .left, // Align the text inside the container to the left
          ),
        ),
        const SizedBox(height: 16),
        Text(
          sub3,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 26,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 9),
        Text(
          date3,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 16),
        Text(
          description3,
          style: const TextStyle(
            fontFamily: 'Segoe',
            fontWeight: FontWeight.w400,
            color: Colors.white,
            fontSize: 19,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    ),
  );
}

// Helper function to build an expandable skill tile
Widget _buildExpandableSkillTile(String title, List<String> subSkills) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: Colors.white),
    ),
    child: ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Segoe',
          fontWeight: FontWeight.w400,
          color: Colors.white,
          fontSize: 23,
        ),
      ),
      iconColor: Colors.white, // Customize the arrow color
      collapsedIconColor: Colors.white,
      children: subSkills
          .map(
            (skill) => ListTile(
              title: Text(
                skill,
                style: const TextStyle(
                  fontFamily: 'Segoe',
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
            ),
          )
          .toList(),
    ),
  );
}
