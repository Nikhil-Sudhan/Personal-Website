import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Map<String, Size> _imageSizes = {};
  final Map<String, DateTime?> _exifDates = {};
  bool _isLoading = true;
  Map<String, List<String>> _organizedPhotos = {};
  List<String> _allPhotos = [];

  @override
  void initState() {
    super.initState();
    _loadGalleryPhotos();
  }

  Future<void> _loadGalleryPhotos() async {
    // List all photos from the gallery folder
    final List<String> photoFiles = [
      // 2025 - August
      'assets/gallery/IMG-20250822-WA0039.jpg',
      // 2025 - June
      'assets/gallery/IMG-20250611-WA0003.jpg',
      // 2025 - May
      'assets/gallery/IMG-20250822-WA0044.jpg',
      'assets/gallery/IMG-20250822-WA0043.jpg',
      // 2025 - April
      'assets/gallery/IMG-20250822-WA0045.jpg',
      // 2025 - March
      'assets/gallery/IMG-20250822-WA0048.jpg',
      // 2025 - January
      'assets/gallery/IMG-20250728-WA0033.jpg',
      'assets/gallery/IMG-20250822-WA0049.jpg',
      // 2024
      'assets/gallery/IMG-20250822-WA0054.jpg',
      'assets/gallery/IMG-20250822-WA0053.jpg',
      'assets/gallery/IMG-20250822-WA0056.jpg',
      'assets/gallery/IMG-20250822-WA0057.jpg',
      'assets/gallery/IMG-20250822-WA0037.jpg',
      //'assets/gallery/IMG-20250822-WA005.jpg',
      'assets/gallery/IMG-20250822-WA0064.jpg',
      'assets/gallery/IMG-20250822-WA0059.jpg',
      // 2023
      'assets/gallery/IMG-20250822-WA0036.jpg',
      'assets/gallery/IMG-20250822-WA0035.jpg',
      'assets/gallery/WhatsApp Image 2023-06-20 at 10.48.02.jpg',
      'assets/gallery/WhatsApp Image 2023-06-15 at 13.01.53.jpg',
    ];

    _allPhotos = photoFiles;
    //await _loadExifDates(photoFiles);
    _organizedPhotos = _organizePhotosByDate(photoFiles);
    await _loadImageSizes();
  }

  Map<String, List<String>> _organizePhotosByDate(List<String> photoPaths) {
    // Use the organization determined by the Python script with EXIF data
    // This is more reliable than trying to read EXIF in Flutter web
    final Map<String, List<String>> organized = {
      '2025 - August': [],
      '2025 - June': [],
      '2025 - May': [],
      '2025 - April': [],
      '2025 - March': [],
      '2025 - January': [],
      '2024': [],
      '2023': [],
    };

    // Manually organize based on the Python script results
    final Map<String, String> photoCategories = {
      'assets/gallery/IMG-20250822-WA0039.jpg': '2025 - August',
      'assets/gallery/IMG-20250611-WA0003.jpg': '2025 - June',
      'assets/gallery/IMG-20250822-WA0044.jpg': '2025 - May',
      'assets/gallery/IMG-20250822-WA0043.jpg': '2025 - May',
      'assets/gallery/IMG-20250822-WA0045.jpg': '2025 - April',
      'assets/gallery/IMG-20250822-WA0048.jpg': '2025 - March',
      'assets/gallery/IMG-20250728-WA0033.jpg': '2025 - January',
      'assets/gallery/IMG-20250822-WA0049.jpg': '2025 - January',
      'assets/gallery/IMG-20250822-WA0054.jpg': '2024',
      'assets/gallery/IMG-20250822-WA0053.jpg': '2024',
      'assets/gallery/IMG-20250822-WA0056.jpg': '2024',
      'assets/gallery/IMG-20250822-WA0057.jpg': '2024',
      'assets/gallery/IMG-20250822-WA0037.jpg': '2024',
      'assets/gallery/IMG-20250822-WA005.jpg': '2024',
      'assets/gallery/IMG-20250822-WA0064.jpg': '2024',
      'assets/gallery/IMG-20250822-WA0059.jpg': '2024',
      'assets/gallery/IMG-20250822-WA0036.jpg': '2023',
      'assets/gallery/IMG-20250822-WA0035.jpg': '2023',
      'assets/gallery/WhatsApp Image 2023-06-20 at 10.48.02.jpg': '2023',
      'assets/gallery/WhatsApp Image 2023-06-15 at 13.01.53.jpg': '2023',
    };

    for (String photoPath in photoPaths) {
      final String category = photoCategories[photoPath] ?? 'Unknown';

      if (!organized.containsKey(category)) {
        organized[category] = [];
      }
      organized[category]!.add(photoPath);

      if (kDebugMode) {
        print('Organizing $photoPath: category = $category');
      }
    }

    // Remove empty categories
    organized.removeWhere((key, value) => value.isEmpty);

    // Sort photos within each category by actual taken date (newest first)
    organized.forEach((key, photos) {
      photos.sort((a, b) {
        // Use EXIF date if available, otherwise fall back to filename date
        final dateA =
            _exifDates[a] ?? _extractDateFromFileName(a.split('/').last);
        final dateB =
            _exifDates[b] ?? _extractDateFromFileName(b.split('/').last);

        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;

        return dateB.compareTo(dateA); // Newest first
      });
    });

    // Sort the keys
    final sortedKeys = organized.keys.toList()
      ..sort((a, b) {
        if (a == 'Unknown') return 1;
        if (b == 'Unknown') return -1;

        if (a.contains(' - ')) {
          // This is a year-month key (2025)
          final yearA = int.parse(a.split(' - ')[0]);
          final monthA = _getMonthNumber(a.split(' - ')[1]);
          if (b.contains(' - ')) {
            final yearB = int.parse(b.split(' - ')[0]);
            final monthB = _getMonthNumber(b.split(' - ')[1]);
            if (yearA != yearB) return yearB.compareTo(yearA);
            return monthB.compareTo(monthA);
          } else {
            final yearB = int.parse(b);
            if (yearA != yearB) return yearB.compareTo(yearA);
            return -1; // Year-month comes before year-only
          }
        } else {
          // This is a year-only key
          final yearA = int.parse(a);
          if (b.contains(' - ')) {
            final yearB = int.parse(b.split(' - ')[0]);
            if (yearA != yearB) return yearB.compareTo(yearA);
            return 1; // Year-only comes after year-month
          } else {
            final yearB = int.parse(b);
            return yearB.compareTo(yearA);
          }
        }
      });

    final Map<String, List<String>> sortedOrganized = {};
    for (String key in sortedKeys) {
      sortedOrganized[key] = organized[key]!;
    }

    return sortedOrganized;
  }

  DateTime? _extractDateFromFileName(String fileName) {
    try {
      // Try to extract date from WhatsApp format: IMG-YYYYMMDD-WAXXXX.jpg
      if (fileName.startsWith('IMG-') && fileName.contains('-WA')) {
        final String datePart = fileName.substring(4, 12); // Extract YYYYMMDD
        final int year = int.parse(datePart.substring(0, 4));
        final int month = int.parse(datePart.substring(4, 6));
        final int day = int.parse(datePart.substring(6, 8));

        // Extract WhatsApp sequence number for more precise ordering
        final RegExp waRegex = RegExp(r'-WA(\d+)');
        final Match? waMatch = waRegex.firstMatch(fileName);
        int waNumber = 0;
        if (waMatch != null) {
          waNumber = int.parse(waMatch.group(1)!);
        }

        // Add milliseconds based on WA number for same-day sorting
        return DateTime(year, month, day).add(Duration(milliseconds: waNumber));
      }

      // Try to extract date from "WhatsApp Image YYYY-MM-DD at HH.MM.SS.jpg" format
      if (fileName.startsWith('WhatsApp Image ')) {
        final RegExp regex =
            RegExp(r'(\d{4})-(\d{2})-(\d{2}) at (\d+)\.(\d+)\.(\d+)');
        final Match? match = regex.firstMatch(fileName);
        if (match != null) {
          final int year = int.parse(match.group(1)!);
          final int month = int.parse(match.group(2)!);
          final int day = int.parse(match.group(3)!);
          final int hour = int.parse(match.group(4)!);
          final int minute = int.parse(match.group(5)!);
          final int second = int.parse(match.group(6)!);
          return DateTime(year, month, day, hour, minute, second);
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  int _getMonthNumber(String monthName) {
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames.indexOf(monthName) + 1;
  }

  Future<void> _loadImageSizes() async {
    final Map<String, Size> sizes = {};

    for (String imagePath in _allPhotos) {
      try {
        final size = await _getImageSize(imagePath);
        sizes[imagePath] = size;
      } catch (e) {
        // If image fails to load, use default size
        sizes[imagePath] = const Size(100, 100);
      }
    }

    if (mounted) {
      setState(() {
        _imageSizes = sizes;
        _isLoading = false;
      });
    }
  }

  Future<Size> _getImageSize(String imagePath) async {
    final ByteData data = await rootBundle.load(imagePath);
    final ui.Codec codec =
        await ui.instantiateImageCodec(data.buffer.asUint8List());
    final ui.FrameInfo frameInfo = await codec.getNextFrame();
    return Size(
      frameInfo.image.width.toDouble(),
      frameInfo.image.height.toDouble(),
    );
  }

  List<QuiltedGridTile> _generateDynamicBentoPattern(List<String> images) {
    final List<QuiltedGridTile> pattern = [];

    for (String imagePath in images) {
      final size = _imageSizes[imagePath] ?? const Size(100, 100);
      final aspectRatio = size.width / size.height;

      int crossAxisCount = 1;
      int mainAxisCount = 1;

      if (aspectRatio > 1.5) {
        // Wide image - use 2 columns, 1 row
        crossAxisCount = 2;
        mainAxisCount = 1;
      } else if (aspectRatio < 0.7) {
        // Tall image - use 1 column, 2 rows
        crossAxisCount = 1;
        mainAxisCount = 2;
      } else if (aspectRatio > 1.2) {
        // Slightly wide - use 2 columns, 1 row
        crossAxisCount = 2;
        mainAxisCount = 1;
      } else {
        // Square or close to square - use 1x1
        crossAxisCount = 1;
        mainAxisCount = 1;
      }

      pattern.add(QuiltedGridTile(mainAxisCount, crossAxisCount));
    }

    return pattern;
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Text(
                          "gallery",
                          style: TextStyle(
                            fontFamily: 'Segoe',
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8), // Reduced from 16 to 8
                  Expanded(
                    child: _isLoading
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: Colors.lightBlueAccent,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Loading images...',
                                  style: TextStyle(
                                    fontFamily: 'Segoe',
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SingleChildScrollView(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _buildDynamicSections(),
                              ),
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

  List<Widget> _buildDynamicSections() {
    final List<Widget> sections = [];

    _organizedPhotos.forEach((key, images) {
      if (sections.isNotEmpty) {
        sections.add(const SizedBox(height: 16)); // Reduced from 32 to 16
      }
      sections.add(_buildSection(key, images));
    });

    return sections;
  }

  Widget _buildSection(String title, List<String> images) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Segoe',
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 12), // Reduced from 32 to 12
        _buildBentoGrid(images),
      ],
    );
  }

  Widget _buildBentoGrid(List<String> images) {
    if (images.isEmpty) {
      return _buildEmptySection();
    }

    final pattern = _generateDynamicBentoPattern(images);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: StaggeredGrid.count(
        crossAxisCount: 4,
        mainAxisSpacing: 4, // Reduced from 8 to 4
        crossAxisSpacing: 4, // Reduced from 8 to 4
        children: List.generate(images.length, (index) {
          return StaggeredGridTile.count(
            crossAxisCellCount: pattern[index].crossAxisCount,
            mainAxisCellCount: pattern[index].mainAxisCount,
            child: _buildDynamicBentoItem(images[index]),
          );
        }),
      ),
    );
  }

  Widget _buildDynamicBentoItem(String assetPath) {
    final imageSize = _imageSizes[assetPath] ?? const Size(100, 100);
    final aspectRatio = imageSize.width / imageSize.height;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Image.asset(
            assetPath,
            fit: BoxFit
                .contain, // Changed from cover to contain to show full image
            errorBuilder: (context, error, stack) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent[400],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 32,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Image not found',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySection() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent[400],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library,
              color: Colors.white,
              size: 48,
            ),
            SizedBox(height: 16),
            Text(
              'No images available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Segoe',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
