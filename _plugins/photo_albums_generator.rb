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

    # Factory method for creating albums from config
    def self.from_config(site, config_entry)
      album = allocate
      album.send(:init_from_config, site, config_entry)
      album
    end

    def load_photos
      image_extensions = %w[.jpg .jpeg .png .gif .webp]

      # Use @path (set by either initialize or init_from_config) for loading files
      return [] unless Dir.exist?(@path)

      files = Dir.glob(File.join(@path, '*')).select do |file|
        File.file?(file) && image_extensions.include?(File.extname(file).downcase)
      end.sort

      files.each_with_index.map do |file, index|
        original_filename = File.basename(file)
        extension = File.extname(original_filename)

        # For albums from source, use sequential filenames; for resized, keep original
        if @from_resized
          # Already resized - keep existing filename
          output_filename = original_filename
          url_folder = File.basename(@path)
        else
          # Will be resized - use sequential filename
          output_filename = "%03d#{extension}" % (index + 1)
          url_folder = @name
        end

        resized_url = "/photos/resized/#{url_folder}/#{output_filename}"

        {
          'path' => file.sub(@site.source, ''),
          'filename' => output_filename,
          'original_filename' => original_filename,
          'url' => resized_url,
          'original_url' => resized_url,
          'resized_url' => resized_url,
          'source_path' => @from_resized ? nil : file  # Only set source if from albums, not resized
        }
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
        'date' => @date ? @date.to_s : nil,
        'path' => @path.sub(@site.source, ''),
        'photos' => @photos,
        'photo_count' => photo_count,
        'thumbnail_url' => thumbnail_url,
        'url' => "/photos/#{@slug}/"
      }
    end

    protected

    def init_from_config(site, config)
      @site = site
      @title = config['title']
      @slug = config['slug']
      @date = config['date'] ? Date.parse(config['date']) : nil
      @name = @slug  # Critical: use slug as name for URL generation

      # Detect actual images path (handle both albums/ and resized/ locations)
      images_path = config['images_path']
      @path, @from_resized = detect_images_path(site, images_path)
      @photos = load_photos
    end

    private

    def detect_images_path(site, configured_path)
      full_path = File.join(site.source, configured_path)

      # Try configured path first
      if Dir.exist?(full_path) && has_images?(full_path)
        from_resized = configured_path.include?('/resized/')
        Jekyll.logger.debug "Photo Albums:", "Using configured path: #{configured_path}"
        return [full_path, from_resized]
      end

      # Try alternate location (swap albums<->resized)
      alternate_path = if configured_path.include?('/albums/')
        configured_path.sub('/albums/', '/resized/')
      elsif configured_path.include?('/resized/')
        configured_path.sub('/resized/', '/albums/')
      else
        nil
      end

      if alternate_path
        full_alternate = File.join(site.source, alternate_path)
        if Dir.exist?(full_alternate) && has_images?(full_alternate)
          from_resized = alternate_path.include?('/resized/')
          Jekyll.logger.debug "Photo Albums:", "Using alternate path: #{alternate_path}"
          return [full_alternate, from_resized]
        end
      end

      # Fallback to original path even if empty
      Jekyll.logger.warn "Photo Albums:", "No images found at #{configured_path} or alternate locations"
      from_resized = configured_path.include?('/resized/')
      [full_path, from_resized]
    end

    def has_images?(path)
      image_extensions = %w[.jpg .jpeg .png .gif .webp]
      Dir.glob(File.join(path, '*')).any? do |file|
        File.file?(file) && image_extensions.include?(File.extname(file).downcase)
      end
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
      self.read_yaml(File.join(@base, '_layouts'), 'album_standalone.html')

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
      config_path = File.join(site.source, '_data', 'photo_albums.yml')

      if File.exist?(config_path)
        # CONFIG-BASED MODE
        Jekyll.logger.info "Photo Albums:", "Using config-based album definitions"
        albums = load_from_config(site, config_path)
      else
        # FOLDER-BASED MODE (backward compatibility)
        Jekyll.logger.info "Photo Albums:", "No config found, using folder-based discovery"
        albums = load_from_folders(site)
      end

      # Generate pages for each album with pagination
      albums.each do |album|
        photos_per_page = 20
        total_pages = (album.photo_count.to_f / photos_per_page).ceil

        (1..total_pages).each do |page_num|
          site.pages << AlbumPage.new(site, album, page_num, total_pages)
        end
      end

      # Make albums available to templates
      site.data['photo_albums'] = albums.map(&:to_liquid)
      Jekyll.logger.info "Photo Albums:", "Found #{albums.length} album(s)"

      # Store albums that need processing for post-write hook (only those not from_resized)
      albums_to_process = albums.reject { |a| a.from_resized }
      site.config['photo_albums_data'] = albums_to_process
      Jekyll.logger.info "Photo Albums:", "#{albums_to_process.length} album(s) will be processed for resizing"
    end

    private

    def load_from_config(site, config_path)
      albums = []

      begin
        config_data = YAML.load_file(config_path)

        if config_data && config_data['albums']
          config_data['albums'].each do |album_config|
            album = PhotoAlbum.from_config(site, album_config)

            if album.photo_count.zero?
              Jekyll.logger.warn "Photo Albums:", "Skipping '#{album.title}' - no photos found"
              next
            end

            # Store position for sorting
            album.instance_variable_set(:@position, album_config['position'] || 999)
            albums << album
          end

          # Sort by position (ascending)
          albums.sort_by! { |a| a.instance_variable_get(:@position) }
        else
          Jekyll.logger.warn "Photo Albums:", "Config file exists but has no 'albums' key"
        end
      rescue => e
        Jekyll.logger.error "Photo Albums:", "Error reading config: #{e.message}"
      end

      albums
    end

    def load_from_folders(site)
      albums = []
      use_resized = false

      albums_path = File.join(site.source, 'photos', 'albums')
      resized_path = File.join(site.source, 'photos', 'resized')

      # Check which folder actually has album subdirectories
      albums_folders = Dir.exist?(albums_path) ? Dir.glob(File.join(albums_path, '*')).select { |f| File.directory?(f) } : []
      resized_folders = Dir.exist?(resized_path) ? Dir.glob(File.join(resized_path, '*')).select { |f| File.directory?(f) } : []

      # Prefer albums (local development) if it has content, otherwise use resized (GitHub Pages)
      if albums_folders.any?
        # Local development: process from hi-res albums
        Jekyll.logger.info "Photo Albums:", "Processing from hi-res albums folder"
        albums_folders.each do |album_path|
          album = PhotoAlbum.new(site, album_path, from_resized: false)
          next if album.photo_count.zero?
          albums << album
        end
      elsif resized_folders.any?
        # GitHub Pages: use pre-generated resized photos
        Jekyll.logger.info "Photo Albums:", "Using pre-generated resized photos"
        use_resized = true
        resized_folders.each do |album_path|
          album = PhotoAlbum.new(site, album_path, from_resized: true)
          next if album.photo_count.zero?
          albums << album
        end
      else
        # No albums or resized folder found
        Jekyll.logger.warn "Photo Albums:", "No albums or resized photos found"
        return []
      end

      # Sort albums by date (newest first) - original behavior
      albums.sort_by! { |a| a.date || Date.new(1970, 1, 1) }.reverse!

      albums
    end
  end

  # Hook to resize images and backup hi-res photos after site is written
  Jekyll::Hooks.register :site, :post_write do |site|
    albums = site.config['photo_albums_data'] || []

    albums.each do |album|
      album.photos.each do |photo|
        source_path = photo['source_path']
        next unless source_path  # Skip if no source (already using resized)

        original_filename = File.basename(source_path)
        sequential_filename = photo['filename']  # 001.jpg, 002.jpg, etc.

        # For config-based albums, album.name is the slug
        # Extract actual folder name from path for hi-res backup
        source_folder_name = File.basename(File.dirname(source_path))

        # 1. Backup hi-res photo to hi-res-photos/ folder using original filename
        hires_backup_dir = File.join(site.source, 'hi-res-photos', source_folder_name)
        FileUtils.mkdir_p(hires_backup_dir)
        hires_backup_path = File.join(hires_backup_dir, original_filename)

        # Copy hi-res photo to backup folder if it doesn't exist or is older
        if !File.exist?(hires_backup_path) || File.mtime(source_path) > File.mtime(hires_backup_path)
          FileUtils.cp(source_path, hires_backup_path)
          Jekyll.logger.info "Backed up hi-res:", "#{original_filename}"
        end

        # 2. Create resized version for _site using sequential filename
        resized_dir_site = File.join(site.dest, 'photos', 'resized', album.name)
        FileUtils.mkdir_p(resized_dir_site)
        resized_path_site = File.join(resized_dir_site, sequential_filename)

        # 3. Also create resized version in source (for git commit) using sequential filename
        resized_dir_source = File.join(site.source, 'photos', 'resized', album.name)
        FileUtils.mkdir_p(resized_dir_source)
        resized_path_source = File.join(resized_dir_source, sequential_filename)

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

            # Write to both _site and source using sequential filename
            image.write(resized_path_site)
            image.write(resized_path_source)
            Jekyll.logger.info "Resized:", "#{original_filename} -> #{sequential_filename}"
          rescue => e
            Jekyll.logger.warn "Photo resize error:", "#{original_filename}: #{e.message}"
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
