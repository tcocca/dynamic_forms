if defined?(ActionController::Routing::RouteSet)
  class ActionController::Routing::RouteSet
    def load_routes_with_dynamic_forms!
      lib_path = File.dirname(__FILE__)
      dynamic_forms_routes = File.join(lib_path, *%w[.. .. .. config dynamic_forms_routes.rb])
      unless configuration_files.include?(dynamic_forms_routes)
        add_configuration_file(dynamic_forms_routes)
      end
      load_routes_without_dynamic_forms!
    end
 
    alias_method_chain :load_routes!, :dynamic_forms
  end
end