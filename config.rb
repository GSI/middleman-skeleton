###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", :layout => false
#
# With alternative layout
# page "/path/to/file.html", :layout => :otherlayout
#
# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", :locals => {
#  :which_fake_page => "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
activate :livereload

activate :i18n

# Generate thumbnail versions of your jpeg & png images
#activate :thumbnailer,
#  :dimensions => {
#    :small => 'x100',
#    :medium => '400x300'
#  },
#  :include_data_thumbnails => true, :namespace_directory => %w(gallery)

# Methods defined in the helpers block are available in templates
helpers do

  # http://forum.middlemanapp.com/t/direct-image-tag-to-look-in-the-current-directory/1084/2
  def image_resources_in(dir, recursive)
    dir = "#{settings.images_dir}/#{dir}"
    image_exts = %w{ jpg gif jpeg png }

    images = sitemap.resources.select do |resource|
      resource_dir = File.dirname(resource.path)
      resource_ext = File.extname(resource.path)[1..-1].try(:downcase)
      
      path_verified = false

      if recursive
        path_verified = resource_dir.start_with?(dir)
      else
        path_verified = dir.eql?(resource_dir)
      end

      path_verified && image_exts.include?(resource_ext)
    end

    images.sort_by(&:source_file)
  end

  def localized_exif_title(img_path)
    # NOTE Set like this: exiftool -title='{"es": "Vista gimnasio", "de": "Ausblick Fitnessraum" , "en": "View from gym"}' 05_edificio_vista_gimnasio_20130924_130109.jpg %>
    begin
      JSON.parse(MiniExiftool.new(img_path).title)[I18n.locale.to_s] if MiniExiftool.new(img_path).title
    rescue JSON::ParserError
      MiniExiftool.new(img_path).title
    end
  end

end


set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript

  # Enable cache buster
  activate :asset_hash

  # Use relative URLs
  # activate :relative_assets

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
	
	# GZIP text files
  activate :gzip

	# Minify HTML
	activate :minify_html

	# Compress images
	# IMPORTANT: Install binaries as explained at
	# https://github.com/toy/image_optim#binaries-installation
	activate :imageoptim do |options|
		options.pngout_options    = false
	end
end


set :domain, ''
set :title, ''
set :piwik_host, 'piwik.example.org'
set :piwik_id, '0'
