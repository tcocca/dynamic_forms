class DynamicFormsGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  
  def self.source_root
   @source_root ||= File.join(File.dirname(__FILE__), 'templates')
  end

  def self.next_migration_number(dirname)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def create_migration_file
    migration_template 'migration.rb', 'db/migrate/create_dynamic_forms.rb'
  end
  
  def copy_config_file
    template 'locales/dynamic_forms.yml', File.join('config', 'locales', 'dynamic_forms.yml')
  end
end
