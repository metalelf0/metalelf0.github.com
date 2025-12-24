# Chirpy Starter

[![Gem Version](https://img.shields.io/gem/v/jekyll-theme-chirpy)][gem]&nbsp;
[![GitHub license](https://img.shields.io/github/license/cotes2020/chirpy-starter.svg?color=blue)][mit]

When installing the [**Chirpy**][chirpy] theme through [RubyGems.org][gem], Jekyll can only read files in the folders
`_data`, `_layouts`, `_includes`, `_sass` and `assets`, as well as a small part of options of the `_config.yml` file
from the theme's gem. If you have ever installed this theme gem, you can use the command
`bundle info --path jekyll-theme-chirpy` to locate these files.

The Jekyll team claims that this is to leave the ball in the user’s court, but this also results in users not being
able to enjoy the out-of-the-box experience when using feature-rich themes.

To fully use all the features of **Chirpy**, you need to copy the other critical files from the theme's gem to your
Jekyll site. The following is a list of targets:

```shell
.
├── _config.yml
├── _plugins
├── _tabs
└── index.html
```

To save you time, and also in case you lose some files while copying, we extract those files/configurations of the
latest version of the **Chirpy** theme and the [CD][CD] workflow to here, so that you can start writing in minutes.

## Usage

Check out the [theme's docs](https://github.com/cotes2020/jekyll-theme-chirpy/wiki).

## Photo Albums

This site includes a custom photo albums system that generates beautiful photo galleries with pagination and automatic image resizing.

### Adding a New Album

Albums are configured in `_data/photo_albums.yml`. To add a new album:

1. **Place your photos** in a folder under `photos/albums/` (e.g., `photos/albums/2025-12-12-paris/`)

2. **Add album configuration** to `_data/photo_albums.yml`:

```yaml
albums:
  - title: "Paris in Winter"
    slug: "paris"
    position: 1
    images_path: "photos/albums/2025-12-12-paris"
    date: "2025-12-12"
```

### Configuration Fields

- **title**: Display name for the album (shown in the gallery listing)
- **slug**: URL-friendly identifier (creates `/photos/[slug]/` pages)
- **position**: Sorting order (lower numbers appear first)
- **images_path**: Relative path from site root to your images folder
  - Can point to `photos/albums/` (local dev) or `photos/resized/` (production)
  - The plugin automatically detects which folder contains images
- **date**: (Optional) Date in YYYY-MM-DD format for display purposes

### Build Process

When you build the site:

1. The plugin reads album definitions from `_data/photo_albums.yml`
2. Photos are automatically resized to 1920px (max dimension) at 85% quality
3. Resized images are saved to `photos/resized/[slug]/`
4. Original hi-res photos are backed up to `hi-res-photos/` (gitignored)
5. Album pages are generated with pagination (20 photos per page)
6. URLs use clean slugs: `/photos/paris/` instead of `/photos/2025-12-12-paris/`

### Image Requirements

- Supported formats: JPG, JPEG, PNG, GIF, WebP
- Images are automatically sorted by filename
- Original images can be any size (will be resized automatically)

### Backward Compatibility

If `_data/photo_albums.yml` doesn't exist, the plugin falls back to folder-based discovery:
- Scans `photos/albums/` or `photos/resized/` directories
- Parses dates and titles from folder names (e.g., `2025-12-12-paris`)
- Sorts albums by date (newest first)

## Contributing

This repository is automatically updated with new releases from the theme repository. If you encounter any issues or want to contribute to its improvement, please visit the [theme repository][chirpy] to provide feedback.

## License

This work is published under [MIT][mit] License.

[gem]: https://rubygems.org/gems/jekyll-theme-chirpy
[chirpy]: https://github.com/cotes2020/jekyll-theme-chirpy/
[CD]: https://en.wikipedia.org/wiki/Continuous_deployment
[mit]: https://github.com/cotes2020/chirpy-starter/blob/master/LICENSE
