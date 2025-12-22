# Photo Albums

This directory contains your photo albums. Each album should be in its own subdirectory.

## Creating a New Album

1. Create a new directory with the format: `YYYY-MM-DD-album-name`
   - Example: `2025-12-12-paris` or `2025-10-10-italy`
   - The date is optional, but recommended for proper sorting

2. Add your image files (JPG, JPEG, PNG, GIF, WEBP) to this directory

3. Jekyll will automatically:
   - Generate an album page at `/photos/album-name/`
   - Create pagination if you have more than 20 photos
   - Add the album to the main photos listing page
   - Use the first photo as the album thumbnail

## Album Title Generation

Album titles are automatically generated from the folder name:
- `2025-12-12-paris` → "Paris"
- `2025-10-10-northern-italy` → "Northern Italy"
- The date will be displayed separately as "December 12, 2025"

## Example Structure

```
photos/albums/
├── 2025-12-12-paris/
│   ├── IMG_001.jpg
│   ├── IMG_002.jpg
│   └── IMG_003.jpg
├── 2025-10-10-italy/
│   ├── photo1.jpg
│   ├── photo2.jpg
│   └── photo3.jpg
└── 2024-07-04-summer/
    ├── beach1.jpg
    └── beach2.jpg
```

After adding photos, rebuild your Jekyll site to see the changes.
