require 'mini_magick'
require 'fileutils'

module Jekyll
  class PhotoAlbum
    attr_reader :name, :path, :date, :title, :slug, :photos, :from_resized

    def initialize(site, album_path, from_resized: false)
      @site = site
      @path = album_path
      @name = File.basename(album_path)
      @from_resized = from_resized

      # Parse date and title from folder name (e.g., "2025-12-12-paris")
      if @name =~ /^(\d{4})-(\d{2})-(\d{2})-(.+)$/
        @date = Date.new($1.to_i, $2.to_i, $3.to_i)
        @slug = $4
        @title = $4.split('-').map(&:capitalize).join(' ')
      else
        @date = nil
        @slug = @name
        @title = @name.split('-').map(&:capitalize).join(' ')
      end

      @photos = load_photos
    end

    def load_photos
      image_extensions = %w[.jpg .jpeg .png .gif .webp]

      if @from_resized
        # Load from pre-generated resized folder (GitHub Pages scenario)
        resized_path = File.join(@site.source, 'photos', 'resized', @name)
        return [] unless Dir.exist?(resized_path)

        Dir.glob(File.join(resized_path, '*')).select do |file|
          File.file?(file) && image_extensions.include?(File.extname(file).downcase)
        end.sort.map do |file|
          filename = File.basename(file)
          resized_url = "/photos/resized/#{@name}/#{URI.encode_www_form_component(filename)}"

          {
            'path' => file.sub(@site.source, ''),
            'filename' => filename,
            'url' => resized_url,
            'original_url' => resized_url,
            'resized_url' => resized_url,
            'source_path' => nil  # No source path when reading from resized
          }
        end
      else
        # Load from hi-res albums folder (local development scenario)
        Dir.glob(File.join(@path, '*')).select do |file|
          File.file?(file) && image_extensions.include?(File.extname(file).downcase)
        end.sort.map do |file|
          filename = File.basename(file)
          resized_url = "/photos/resized/#{@name}/#{URI.encode_www_form_component(filename)}"

          {
            'path' => file.sub(@site.source, ''),
            'filename' => filename,
            'url' => resized_url,
            'original_url' => resized_url,
            'resized_url' => resized_url,
            'source_path' => file
          }
        end
      end
    end

    def photo_count
      @photos.length
    end

    def thumbnail_url
      @photos.first ? @photos.first['resized_url'] : nil
    end

    def to_liquid
      {
        'name' => @name,
        'title' => @title,
        'slug' => @slug,
        'date' => @date,
        'path' => @path.sub(@site.source, ''),
        'photos' => @photos,
        'photo_count' => photo_count,
        'thumbnail_url' => thumbnail_url,
        'url' => "/photos/#{@slug}/"
      }
    end
  end

  class AlbumPage < Page
    def initialize(site, album, page_num = 1, total_pages = 1)
      @site = site
      @base = site.source

      # For page 1, use /photos/album-name/, for others use /photos/album-name/page/2/
      if page_num == 1
        @dir = "photos/#{album.slug}"
        @name = 'index.html'
      else
        @dir = "photos/#{album.slug}/page/#{page_num}"
        @name = 'index.html'
      end

      self.process(@name)
      self.read_yaml(File.join(@base, '_layouts'), 'album.html')

      photos_per_page = 20
      start_idx = (page_num - 1) * photos_per_page
      end_idx = [start_idx + photos_per_page, album.photos.length].min

      self.data['album'] = album.to_liquid
      self.data['photos'] = album.photos[start_idx...end_idx]
      self.data['page_num'] = page_num
      self.data['total_pages'] = total_pages
      self.data['has_prev'] = page_num > 1
      self.data['has_next'] = page_num < total_pages
      self.data['prev_url'] = page_num == 2 ? "/photos/#{album.slug}/" : "/photos/#{album.slug}/page/#{page_num - 1}/"
      self.data['next_url'] = "/photos/#{album.slug}/page/#{page_num + 1}/"
      self.data['title'] = album.title
    end
  end

  class PhotoAlbumsGenerator < Generator
    safe true
    priority :low

    def generate(site)
      albums_path = File.join(site.source, 'photos', 'albums')
      resized_path = File.join(site.source, 'photos', 'resized')

      albums = []
      use_resized = false

      # Check if we should read from albums (local) or resized (GitHub Pages)
      if Dir.exist?(albums_path)
        # Local development: process from hi-res albums
        Jekyll.logger.info "Photo Albums:", "Processing from hi-res albums folder"
        Dir.glob(File.join(albums_path, '*')).select { |f| File.directory?(f) }.each do |album_path|
          album = PhotoAlbum.new(site, album_path, from_resized: false)
          next if album.photo_count.zero?
          albums << album
        end
      elsif Dir.exist?(resized_path)
        # GitHub Pages: use pre-generated resized photos
        Jekyll.logger.info "Photo Albums:", "Using pre-generated resized photos"
        use_resized = true
        Dir.glob(File.join(resized_path, '*')).select { |f| File.directory?(f) }.each do |album_path|
          album = PhotoAlbum.new(site, album_path, from_resized: true)
          next if album.photo_count.zero?
          albums << album
        end
      else
        # No albums or resized folder found
        Jekyll.logger.warn "Photo Albums:", "No albums or resized photos found"
        return
      end

      # Generate pages for each album with pagination
      albums.each do |album|
        photos_per_page = 20
        total_pages = (album.photo_count.to_f / photos_per_page).ceil

        (1..total_pages).each do |page_num|
          site.pages << AlbumPage.new(site, album, page_num, total_pages)
        end
      end

      # Sort albums by date (newest first)
      albums.sort_by! { |a| a.date || Date.new(1970, 1, 1) }.reverse!

      # Make albums available to the photos listing page
      site.data['photo_albums'] = albums.map(&:to_liquid)

      # Store albums for post-write hook (only if processing from source)
      site.config['photo_albums_data'] = use_resized ? [] : albums
    end
  end

  # Hook to resize images and backup hi-res photos after site is written
  Jekyll::Hooks.register :site, :post_write do |site|
    albums = site.config['photo_albums_data'] || []

    albums.each do |album|
      album.photos.each do |photo|
        source_path = photo['source_path']
        next unless source_path  # Skip if no source (already using resized)

        filename = File.basename(source_path)

        # 1. Backup hi-res photo to hi-res-photos/ folder at root
        hires_backup_dir = File.join(site.source, 'hi-res-photos', album.name)
        FileUtils.mkdir_p(hires_backup_dir)
        hires_backup_path = File.join(hires_backup_dir, filename)

        # Copy hi-res photo to backup folder if it doesn't exist or is older
        if !File.exist?(hires_backup_path) || File.mtime(source_path) > File.mtime(hires_backup_path)
          FileUtils.cp(source_path, hires_backup_path)
          Jekyll.logger.info "Backed up hi-res:", "#{filename}"
        end

        # 2. Create resized version for _site
        resized_dir_site = File.join(site.dest, 'photos', 'resized', album.name)
        FileUtils.mkdir_p(resized_dir_site)
        resized_path_site = File.join(resized_dir_site, filename)

        # 3. Also create resized version in source (for git commit)
        resized_dir_source = File.join(site.source, 'photos', 'resized', album.name)
        FileUtils.mkdir_p(resized_dir_source)
        resized_path_source = File.join(resized_dir_source, filename)

        # Only resize if needed
        if !File.exist?(resized_path_site) || File.mtime(source_path) > File.mtime(resized_path_site)
          begin
            image = MiniMagick::Image.open(source_path)

            # Resize to 1920px on the longer side
            if image.width > image.height
              image.resize "1920x" if image.width > 1920
            else
              image.resize "x1920" if image.height > 1920
            end

            # Set quality to 85 for good balance between size and quality
            image.quality "85"

            # Write to both _site and source
            image.write(resized_path_site)
            image.write(resized_path_source)
            Jekyll.logger.info "Resized:", "#{filename}"
          rescue => e
            Jekyll.logger.warn "Photo resize error:", "#{filename}: #{e.message}"
            # If resize fails, copy the original
            FileUtils.cp(source_path, resized_path_site)
            FileUtils.cp(source_path, resized_path_source)
          end
        elsif !File.exist?(resized_path_source)
          # Resized version exists in _site but not in source, copy it
          FileUtils.cp(resized_path_site, resized_path_source)
        end
      end
    end
  end
end
