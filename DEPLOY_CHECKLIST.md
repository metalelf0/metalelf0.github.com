# GitHub Pages Deployment Checklist

## What's in Git Repo

✅ `photos/resized/` - Resized photos (10MB per album)
✅ `_config.yml` - With `keep_files: [photos/resized]`
✅ `_plugins/photo_albums_generator.rb` - Dual-mode plugin
✅ `.gitignore` - Excludes `_site`, `photos/albums`, `hi-res-photos`

❌ `photos/albums/` - NOT in repo (gitignored)
❌ `hi-res-photos/` - NOT in repo (gitignored)
❌ `_site/` - NOT in repo (gitignored)

## Verifying GitHub Pages Build

1. **Check GitHub Actions**
   - Go to: https://github.com/metalelf0/metalelf0.github.com/actions
   - Look for the latest workflow run
   - Should show "pages build and deployment"
   - Wait for it to complete (green checkmark)

2. **Check if photos are deployed**
   - Visit: `https://www.andreaschiavini.com/photos/resized/2025-12-12-paris/R0001945.jpg`
   - Should show the resized photo directly
   - If 404, the photos weren't deployed

3. **Check the album page**
   - Visit: `https://www.andreaschiavini.com/photos/`
   - Should show the Paris album card
   - Click to view: `https://www.andreaschiavini.com/photos/paris/`

## Common Issues

### Issue: "No photo albums found"
**Cause**: Plugin didn't find `photos/resized/` folder
**Fix**: Verify files are in git repo with `git ls-tree -r HEAD --name-only | grep photos/resized`

### Issue: Photos not appearing
**Cause**: Jekyll didn't copy static files
**Fix**: Added `keep_files: [photos/resized]` to `_config.yml` ✅

### Issue: 404 on image files
**Cause**: Static files not in `_site/`
**Solution**: Check GitHub Actions logs for errors

## Debug Commands (Local)

```bash
# Verify resized photos are committed
git ls-tree -r HEAD --name-only | grep photos/resized

# Test GitHub Pages scenario (without albums folder)
mv photos/albums photos/albums_temp
bundle exec jekyll build
# Should see: "Photo Albums: Using pre-generated resized photos"
mv photos/albums_temp photos/albums

# Check build output
ls _site/photos/resized/2025-12-12-paris/
```

## Adding New Albums

1. Add hi-res to `photos/albums/YYYY-MM-DD-name/`
2. Build: `bundle exec jekyll build`
3. Commit resized: `git add photos/resized/ && git commit -m "Add album" && git push`
4. Wait for GitHub Actions to deploy (~1-2 minutes)
