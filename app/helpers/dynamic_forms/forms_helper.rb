# Helpers for creating/editing Forms
module DynamicForms
  module FormsHelper
    
    def link_to_add_field(name, f, association, conatiner_id, subclass = nil)
      if subclass
        new_object = subclass.constantize.new
      else
        new_object = f.object.class.reflect_on_association(association).klass.new
      end
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render :partial => "forms/#{association.to_s.singularize}", :locals => {:f => builder} 
      end
      link_to_function(name, h("add_field(\"#{conatiner_id}\", \"#{association}\", \"#{escape_javascript(fields)}\")"))
    end
    
    def link_to_add_field_option(name, f, association)
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render :partial => "forms/#{association.to_s.singularize}", :locals => {:f => builder} 
      end
      link_to_function(name, h("add_field_option(this, \"#{association}\", \"#{escape_javascript(fields)}\")"))
    end
    
    def link_to_remove_field(name, f)
      f.hidden_field(:_destroy) + link_to_function(name, "remove_field(this)")
    end
    
    def link_to_remove_field_option(name, f)
      f.hidden_field(:_destroy) + link_to_function(name, "remove_field_option(this)")
    end
    
  end
end
