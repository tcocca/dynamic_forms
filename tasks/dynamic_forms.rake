require 'fileutils'

namespace :dynamic_forms do
  def remove_files(templates_path, app_path)
    Dir.foreach(templates_path) do |filename|
      next if filename =~ /^\./
      dest_path = File.join(app_path, filename)
      next unless File.exist?(dest_path)
      FileUtils.rm_rf(dest_path)
    end
  end
  
  task :uninstall do 
    RAILS_ROOT = File.join(File.dirname(__FILE__), '..', '..', '..', '..')
    
    # delete the generated models
    templates_path = File.join(File.dirname(__FILE__), '..', 'generators', 'dynamic_forms', 'templates', 'models')
    app_path = File.join(RAILS_ROOT, 'app', 'models')
    remove_files(templates_path, app_path)
  end
end
