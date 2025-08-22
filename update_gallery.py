#!/usr/bin/env python3
"""
Script to automatically update the photo list in gallery.dart
Scans the assets/gallery folder and updates the photo list with proper organization
"""

import os
import re
from datetime import datetime, timedelta
from pathlib import Path
from PIL import Image
from PIL.ExifTags import TAGS

def extract_exif_date(file_path):
    """Extract the actual photo taken date from EXIF data"""
    try:
        with Image.open(file_path) as image:
            exif_data = image._getexif()
            
            if exif_data is not None:
                # Try different EXIF date tags
                for tag_id in [36867, 306, 36868]:  # DateTimeOriginal, DateTime, DateTimeDigitized
                    if tag_id in exif_data:
                        date_str = exif_data[tag_id]
                        try:
                            # EXIF date format: "2025:01:22 16:46:30"
                            return datetime.strptime(date_str, '%Y:%m:%d %H:%M:%S')
                        except ValueError:
                            continue
    except Exception as e:
        print(f"Error reading EXIF from {file_path}: {e}")
    
    return None

def extract_date_from_filename(filename):
    """Extract date from filename using various patterns"""
    # Pattern 1: IMG-YYYYMMDD-WAXXXX.jpg
    match = re.match(r'IMG-(\d{8})-WA(\d+)\.(jpg|jpeg|png|gif|bmp|webp)', filename)
    if match:
        date_str = match.group(1)
        wa_number = int(match.group(2))
        try:
            base_date = datetime.strptime(date_str, '%Y%m%d')
            # Add microseconds based on WA number for same-day sorting
            return base_date + timedelta(microseconds=wa_number)
        except ValueError:
            pass
    
    # Pattern 2: WhatsApp Image YYYY-MM-DD at HH.MM.SS.jpg
    match = re.match(r'WhatsApp Image (\d{4})-(\d{2})-(\d{2}) at (\d+)\.(\d+)\.(\d+)\.(jpg|jpeg|png|gif|bmp|webp)', filename)
    if match:
        try:
            year = int(match.group(1))
            month = int(match.group(2))
            day = int(match.group(3))
            hour = int(match.group(4))
            minute = int(match.group(5))
            second = int(match.group(6))
            return datetime(year, month, day, hour, minute, second)
        except ValueError:
            pass
    
    # Pattern 3: Any filename with YYYYMMDD or YYYY-MM-DD
    date_patterns = [
        r'(\d{4})(\d{2})(\d{2})',  # YYYYMMDD
        r'(\d{4})-(\d{2})-(\d{2})',  # YYYY-MM-DD
    ]
    
    for pattern in date_patterns:
        match = re.search(pattern, filename)
        if match:
            try:
                if len(match.groups()) == 3:
                    return datetime(int(match.group(1)), int(match.group(2)), int(match.group(3)))
                elif len(match.groups()) == 1:
                    date_str = match.group(1)
                    return datetime.strptime(date_str, '%Y%m%d')
            except ValueError:
                pass
    
    return None

def get_image_files(gallery_path):
    """Get all image files from the gallery folder"""
    image_extensions = {'.jpg', '.jpeg', '.png', '.gif', '.bmp', '.webp'}
    image_files = []
    
    if not os.path.exists(gallery_path):
        print(f"Gallery path {gallery_path} does not exist!")
        return []
    
    for file in os.listdir(gallery_path):
        file_path = os.path.join(gallery_path, file)
        if os.path.isfile(file_path):
            ext = os.path.splitext(file)[1].lower()
            if ext in image_extensions:
                image_files.append(file)
    
    return sorted(image_files)

def organize_photos_by_date(image_files, gallery_path):
    """Organize photos by date - 2025 by month, others by year"""
    organized = {}
    
    for filename in image_files:
        file_path = os.path.join(gallery_path, filename)
        
        # Try EXIF date first, then fall back to filename date
        date = extract_exif_date(file_path) or extract_date_from_filename(filename)
        
        if date:
            year = date.year
            month = date.month
            
            if year == 2025:
                # For 2025, organize by month
                month_names = [
                    'January', 'February', 'March', 'April', 'May', 'June',
                    'July', 'August', 'September', 'October', 'November', 'December'
                ]
                month_key = f'{year} - {month_names[month - 1]}'
                
                if month_key not in organized:
                    organized[month_key] = []
                organized[month_key].append(filename)
            else:
                # For other years, organize by year only
                year_key = str(year)
                if year_key not in organized:
                    organized[year_key] = []
                organized[year_key].append(filename)
        else:
            # If no date found, put in "Unknown" category
            if 'Unknown' not in organized:
                organized['Unknown'] = []
            organized['Unknown'].append(filename)
    
    # Sort photos within each category by actual taken date (newest first)
    for key in organized:
        organized[key].sort(key=lambda x: extract_exif_date(os.path.join(gallery_path, x)) or extract_date_from_filename(x) or datetime.min, reverse=True)
    
    # Sort the keys
    def sort_key(key):
        if key == 'Unknown':
            return (9999, 13)  # Put Unknown at the end
        
        if ' - ' in key:
            # Year-month key (2025)
            year = int(key.split(' - ')[0])
            month_name = key.split(' - ')[1]
            month_names = [
                'January', 'February', 'March', 'April', 'May', 'June',
                'July', 'August', 'September', 'October', 'November', 'December'
            ]
            month = month_names.index(month_name) + 1
            return (year, month)
        else:
            # Year-only key
            year = int(key)
            return (year, 0)
    
    sorted_keys = sorted(organized.keys(), key=sort_key, reverse=True)
    
    sorted_organized = {}
    for key in sorted_keys:
        sorted_organized[key] = organized[key]
    
    return sorted_organized

def generate_dart_code(organized_photos):
    """Generate the Dart code for the photo list and organization mapping"""
    lines = []
    lines.append("  Future<void> _loadGalleryPhotos() async {")
    lines.append("    // List all photos from the gallery folder")
    lines.append("    final List<String> photoFiles = [")
    
    # Generate photo list
    for category, photos in organized_photos.items():
        if photos:
            lines.append(f"      // {category}")
            for photo in photos:
                lines.append(f"      'assets/gallery/{photo}',")
    
    lines.append("    ];")
    lines.append("    ")
    lines.append("    _allPhotos = photoFiles;")
    lines.append("    await _loadExifDates(photoFiles);")
    lines.append("    _organizedPhotos = _organizePhotosByDate(photoFiles);")
    lines.append("    await _loadImageSizes();")
    lines.append("  }")
    
    # Generate organization mapping
    lines.append("")
    lines.append("  Map<String, List<String>> _organizePhotosByDate(List<String> photoPaths) {")
    lines.append("    // Use the organization determined by the Python script with EXIF data")
    lines.append("    // This is more reliable than trying to read EXIF in Flutter web")
    lines.append("    final Map<String, List<String>> organized = {")
    
    for category in organized_photos.keys():
        if organized_photos[category]:  # Only include non-empty categories
            lines.append(f"      '{category}': [],")
    
    lines.append("    };")
    lines.append("")
    lines.append("    // Manually organize based on the Python script results")
    lines.append("    final Map<String, String> photoCategories = {")
    
    for category, photos in organized_photos.items():
        for photo in photos:
            lines.append(f"      'assets/gallery/{photo}': '{category}',")
    
    lines.append("    };")
    lines.append("")
    lines.append("    for (String photoPath in photoPaths) {")
    lines.append("      final String category = photoCategories[photoPath] ?? 'Unknown';")
    lines.append("      ")
    lines.append("      if (!organized.containsKey(category)) {")
    lines.append("        organized[category] = [];")
    lines.append("      }")
    lines.append("      organized[category]!.add(photoPath);")
    lines.append("")
    lines.append("      if (kDebugMode) {")
    lines.append("        print('Organizing $photoPath: category = $category');")
    lines.append("      }")
    lines.append("    }")
    lines.append("")
    lines.append("    // Remove empty categories")
    lines.append("    organized.removeWhere((key, value) => value.isEmpty);")
    lines.append("")
    lines.append("    // Sort photos within each category by actual taken date (newest first)")
    lines.append("    organized.forEach((key, photos) {")
    lines.append("      photos.sort((a, b) {")
    lines.append("        // Use EXIF date if available, otherwise fall back to filename date")
    lines.append("        final dateA =")
    lines.append("            _exifDates[a] ?? _extractDateFromFileName(a.split('/').last);")
    lines.append("        final dateB =")
    lines.append("            _exifDates[b] ?? _extractDateFromFileName(b.split('/').last);")
    lines.append("")
    lines.append("        if (dateA == null && dateB == null) return 0;")
    lines.append("        if (dateA == null) return 1;")
    lines.append("        if (dateB == null) return -1;")
    lines.append("")
    lines.append("        return dateB.compareTo(dateA); // Newest first")
    lines.append("      });")
    lines.append("    });")
    lines.append("")
    lines.append("    // Sort the keys")
    lines.append("    final sortedKeys = organized.keys.toList()")
    lines.append("      ..sort((a, b) {")
    lines.append("        if (a == 'Unknown') return 1;")
    lines.append("        if (b == 'Unknown') return -1;")
    lines.append("")
    lines.append("        if (a.contains(' - ')) {")
    lines.append("          // This is a year-month key (2025)")
    lines.append("          final yearA = int.parse(a.split(' - ')[0]);")
    lines.append("          final monthA = _getMonthNumber(a.split(' - ')[1]);")
    lines.append("          if (b.contains(' - ')) {")
    lines.append("            final yearB = int.parse(b.split(' - ')[0]);")
    lines.append("            final monthB = _getMonthNumber(b.split(' - ')[1]);")
    lines.append("            if (yearA != yearB) return yearB.compareTo(yearA);")
    lines.append("            return monthB.compareTo(monthA);")
    lines.append("          } else {")
    lines.append("            final yearB = int.parse(b);")
    lines.append("            if (yearA != yearB) return yearB.compareTo(yearA);")
    lines.append("            return -1; // Year-month comes before year-only")
    lines.append("          }")
    lines.append("        } else {")
    lines.append("          // This is a year-only key")
    lines.append("          final yearA = int.parse(a);")
    lines.append("          if (b.contains(' - ')) {")
    lines.append("            final yearB = int.parse(b.split(' - ')[0]);")
    lines.append("            if (yearA != yearB) return yearB.compareTo(yearA);")
    lines.append("            return 1; // Year-only comes after year-month")
    lines.append("          } else {")
    lines.append("            final yearB = int.parse(b);")
    lines.append("            return yearB.compareTo(yearA);")
    lines.append("          }")
    lines.append("        }")
    lines.append("      });")
    lines.append("")
    lines.append("    final Map<String, List<String>> sortedOrganized = {};")
    lines.append("    for (String key in sortedKeys) {")
    lines.append("      sortedOrganized[key] = organized[key]!;")
    lines.append("    }")
    lines.append("")
    lines.append("    return sortedOrganized;")
    lines.append("  }")
    
    return '\n'.join(lines)

def update_gallery_dart(gallery_path, dart_file_path):
    """Update the gallery.dart file with new photo list"""
    print("Scanning gallery folder...")
    image_files = get_image_files(gallery_path)
    
    if not image_files:
        print("No image files found!")
        return
    
    print(f"Found {len(image_files)} image files")
    
    # Organize photos by date
    organized_photos = organize_photos_by_date(image_files, gallery_path)
    
    print("\nOrganized photos:")
    for category, photos in organized_photos.items():
        print(f"  {category}: {len(photos)} photos")
    
    # Generate new Dart code
    new_dart_code = generate_dart_code(organized_photos)
    
    # Read the current dart file
    try:
        with open(dart_file_path, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"File {dart_file_path} not found!")
        return
    
    # Find and replace the _loadGalleryPhotos and _organizePhotosByDate methods
    pattern = r'  Future<void> _loadGalleryPhotos\(\) async \{[\s\S]*?return sortedOrganized;\s*\n  \}'
    replacement = new_dart_code
    
    if re.search(pattern, content):
        new_content = re.sub(pattern, replacement, content)
        
        # Write the updated content back
        with open(dart_file_path, 'w', encoding='utf-8') as f:
            f.write(new_content)
        
        print(f"\n✅ Successfully updated {dart_file_path}")
        print("The gallery will now display photos organized by:")
        for category in organized_photos.keys():
            print(f"  - {category}")
    else:
        print("❌ Could not find _loadGalleryPhotos method in the dart file")
        print("Please make sure the method exists and has the expected format")

def main():
    # Paths
    gallery_path = "assets/gallery"
    dart_file_path = "lib/gallery.dart"
    
    print("🖼️  Gallery Photo Updater")
    print("=" * 40)
    
    if not os.path.exists(gallery_path):
        print(f"❌ Gallery folder not found: {gallery_path}")
        print("Please make sure the assets/gallery folder exists")
        return
    
    if not os.path.exists(dart_file_path):
        print(f"❌ Dart file not found: {dart_file_path}")
        print("Please make sure lib/gallery.dart exists")
        return
    
    update_gallery_dart(gallery_path, dart_file_path)
    
    print("\n🎉 Done! You can now run your Flutter app to see the updated gallery.")

if __name__ == "__main__":
    main()
