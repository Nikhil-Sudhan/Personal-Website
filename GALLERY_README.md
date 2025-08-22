# Dynamic Gallery System

## Overview

Your gallery has been updated to automatically organize photos by year and month (for 2025 photos) based on the date information in the filenames. The system is now dynamic and will automatically categorize photos when you add new ones to the `assets/gallery` folder.

## How It Works

### Photo Organization Rules

1. **2025 Photos**: Organized by month (e.g., "2025 - August", "2025 - July")
2. **Other Years**: Organized by year only (e.g., "2023", "2024")
3. **Unknown Dates**: Photos without date information go to "Unknown" category

### Supported Date Formats

The system automatically detects dates from these filename patterns:

- **WhatsApp IMG format**: `IMG-20250822-WA0064.jpg` (August 22, 2025)
- **WhatsApp Image format**: `WhatsApp Image 2023-06-20 at 10.48.02.jpg` (June 20, 2023)
- **General date formats**: Any filename containing `YYYYMMDD` or `YYYY-MM-DD`

## Current Organization

Based on your current gallery, photos are organized as:

- **2025 - August**: 25 photos (IMG-20250822-WA00XX.jpg)
- **2025 - July**: 1 photo (IMG-20250728-WA0033.jpg)
- **2025 - June**: 1 photo (IMG-20250611-WA0003.jpg)
- **2023**: 2 photos (WhatsApp Image 2023-06-XX.jpg)

## Adding New Photos

### Method 1: Automatic Update (Recommended)

1. Add your new photos to the `assets/gallery` folder
2. Run the update script:
   ```bash
   python update_gallery.py
   ```
3. The script will automatically:
   - Scan the gallery folder
   - Extract dates from filenames
   - Organize photos by year/month
   - Update the `gallery.dart` file
4. Restart your Flutter app to see the changes

### Method 2: Manual Update

1. Add photos to `assets/gallery` folder
2. Open `lib/gallery.dart`
3. Find the `_loadGalleryPhotos()` method
4. Add new photo paths to the `photoFiles` list
5. The app will automatically organize them by date when it runs

## File Structure

```
assets/
  gallery/
    IMG-20250822-WA0064.jpg  ← August 2025
    IMG-20250822-WA0063.jpg  ← August 2025
    IMG-20250728-WA0033.jpg  ← July 2025
    IMG-20250611-WA0003.jpg  ← June 2025
    WhatsApp Image 2023-06-20 at 10.48.02.jpg  ← June 2023
    WhatsApp Image 2023-06-15 at 13.01.53.jpg  ← June 2023
```

## Features

- **Automatic Date Detection**: Extracts dates from various filename formats
- **Smart Organization**: 2025 photos by month, others by year
- **Dynamic Layout**: Photos are displayed in a beautiful bento grid layout
- **Responsive Design**: Automatically adjusts layout based on image dimensions
- **Error Handling**: Gracefully handles missing or corrupted images

## Troubleshooting

### Photos Not Showing

1. Check that photos are in the `assets/gallery` folder
2. Verify the photo list in `_loadGalleryPhotos()` method
3. Ensure photos are properly declared in `pubspec.yaml` assets section

### Date Not Detected

1. Check filename format matches supported patterns
2. Use the update script to automatically detect dates
3. Photos without dates will appear in "Unknown" category

### Layout Issues

1. The bento grid automatically adjusts based on image dimensions
2. Wide images span 2 columns, tall images span 2 rows
3. Square images use 1x1 layout

## Future Enhancements

- **Automatic Folder Scanning**: Real-time folder monitoring
- **Custom Categories**: User-defined organization rules
- **Search and Filter**: Find photos by date or category
- **Photo Metadata**: Display additional photo information

## Running the Update Script

Make sure you have Python installed, then run:

```bash
cd /path/to/your/Personal-Website
python update_gallery.py
```

The script will show you exactly how your photos are organized and update the code automatically.

---

**Note**: The gallery system is now fully dynamic and will automatically organize any new photos you add to the `assets/gallery` folder based on their filename dates.
