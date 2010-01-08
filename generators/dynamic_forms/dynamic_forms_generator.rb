class DynamicFormsGenerator < Rails::Generator::Base
  
  def manifest
    record do |m|
      m.migration_template 'migrations/create_dynamic_forms.rb', 'db/migrate', :migration_file_name => "create_dynamic_forms"
    end
  end
  
end
