=begin
require 'fileutils'

namespace :dynamic_forms do
  task :uninstall do 
    RAILS_ROOT = File.join(File.dirname(__FILE__), '..', '..', '..', '..')
    
    # delete files from /app that exist in plugin
    %w{controllers helpers models views}.each do |dir|
      dir_path = File.join(File.dirname(__FILE__), '..', 'lib', dir)
      Dir.foreach(dir_path) do |filename|
        next if filename =~ /^\./
        dest_path = File.join(RAILS_ROOT, 'app', dir, filename)
        next unless File.exist?(dest_path)
        FileUtils.rm_rf(dest_path)
      end
    end
    
    def gsub_file(path, regexp, *args, &block)
      content = File.read(path).gsub(regexp, *args, &block)
      File.open(path, 'wb') { |file| file.write(content) }
    end
    
    sentinel = <<-EOF
  map.resources :forms, :collection => {:preview => :post} do |f|
    f.resources :form_submissions
  end
EOF

    # Remove routes from the routes.rb file
    gsub_file(File.join(RAILS_ROOT, 'config', 'routes.rb'), /(#{Regexp.escape(sentinel)})/mi, '')
    
  end
end
=end