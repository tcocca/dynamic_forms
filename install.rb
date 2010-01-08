=begin
require 'fileutils'

RAILS_ROOT = File.join(File.dirname(__FILE__), '..', '..', '..')

# copy files from plugin /lib over to /app
%w{controllers helpers models views}.each do |dir|
  dir_path = File.join('lib', dir)
  Dir.foreach(dir_path) do |filename|
    next if filename =~ /^\./
    dest_path = File.join(RAILS_ROOT, 'app', dir, filename)
    next if File.exist?(dest_path)
    FileUtils.cp_r(File.join(dir_path, filename), dest_path)
  end
end

def gsub_file(path, regexp, *args, &block)
  content = File.read(path).gsub(regexp, *args, &block)
  File.open(path, 'wb') { |file| file.write(content) }
end
 
sentinel = 'ActionController::Routing::Routes.draw do |map|'

# Add routes to the top of the routes.rb file
gsub_file File.join(RAILS_ROOT, 'config', 'routes.rb'), /(#{Regexp.escape(sentinel)})/mi do |match|
  <<-EOF
#{match}\n  
  map.resources :forms, :collection => {:preview => :post} do |f|
    f.resources :form_submissions
  end
EOF
end
=end