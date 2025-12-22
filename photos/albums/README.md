# Photo Albums Source

This folder contains the hi-res source photos for your photo albums.

**⚠️ This folder is gitignored and will NOT be pushed to GitHub.**

## Workflow

### Adding New Photos

1. Create a new album folder with the format: `YYYY-MM-DD-album-name`
   ```
   photos/albums/2025-12-25-christmas/
   ```

2. Add your hi-res photos to the folder

3. Build the site locally:
   ```bash
   bundle exec jekyll build
   ```

4. The build process will:
   - Back up hi-res photos to `hi-res-photos/` (also gitignored)
   - Create resized versions (1920px max) in `photos/resized/`
   - Copy resized versions to your git repo

5. Commit and push the resized photos:
   ```bash
   git add photos/resized/
   git commit -m "Add new photo album"
   git push
   ```

### What Gets Committed to Git

- ✅ `photos/resized/` - Only resized, optimized photos (~10MB per album)
- ❌ `photos/albums/` - Hi-res source photos (gitignored)
- ❌ `hi-res-photos/` - Local backup (gitignored)

### GitHub Pages Deployment

When GitHub Pages builds your site:
- It uses the pre-generated resized photos from `photos/resized/`
- No hi-res processing happens on GitHub
- Albums display correctly without the source files

## File Sizes

- Hi-res sources: ~298MB per album
- Resized (committed): ~10MB per album
- **97% size reduction!**
