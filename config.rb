#Bootstrap is used to style bits of the demo. Remove it from the config, gemfile and stylesheets to stop using bootstrap
require "uglifier"

# Activate and configure extensions
# https://middlemanapp.com/advanced/configuration/#configuring-extensions

# Use '#id' and '.classname' as div shortcuts in slim
# http://slim-lang.com/
Slim::Engine.set_options shortcut: {
  '#' => { tag: 'div', attr: 'id' }, '.' => { tag: 'div', attr: 'class' }
}

activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :livereload
# Layouts
# https://middlemanapp.com/basics/layouts/

# Per-page layout changes
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false
page "/partials/*", layout: false
page "/admin/*", layout: false

# With alternative layout
# page '/path/to/file.html', layout: 'other_layout'

# Proxy pages
# https://middlemanapp.com/advanced/dynamic-pages/

# proxy room.yml files to room.html 
data.rooms.each do |_filename, room|
  # room is an array: [filename, {data}]
  proxy "/rooms/#{room[:title].parameterize}/index.html", "room.html", 
  locals: {room: room}, 
  layout: 'product-detail',
  ignore: true
end

# Helpers
# Methods defined in the helpers block are available in templates
# https://middlemanapp.com/basics/helper-methods/

# pretty urls
activate :directory_indexes

helpers do
  #helper to set background images with asset hashes in a style attribute
  def background_image(image)
    "background-image: url('" << image_path(image) << "')"
  end
  
  def nav_link(link_text, url, options = {})
    options[:class] ||= ""
    options[:class] << " active" if url == current_page.url
    link_to(link_text, url, options)
  end

  def markdown(content)
     Tilt['markdown'].new { content }.render
  end
end

# Build-specific configuration
# https://middlemanapp.com/advanced/configuration/#environment-specific-settings

configure :build do
  # Minify css on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript, ignore: "**/admin/**", compressor: ::Uglifier.new(mangle: true, compress: { drop_console: true }, output: {comments: :none})

  # Use Gzip
  activate :gzip

  #Use asset hashes to use for caching
  #activate :asset_hash

end
