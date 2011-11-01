# Helpers for creating/editing Forms
module DynamicForms
  module FormsHelper
    
    def display_form_field(form_builder, field)
      unless field.field_helper_select_options.nil?
        if field.has_html_options?
          return form_builder.send(field.kind.to_sym, field.name, field.field_helper_select_options, field.field_helper_options, field.field_helper_html_options)
        else
          return form_builder.send(field.kind.to_sym, field.name, field.field_helper_select_options, field.field_helper_options)
        end
      else
        if field.has_html_options?
          return form_builder.send(field.kind.to_sym, field.name, field.field_helper_options, field.field_helper_html_options)
        else
          return form_builder.send(field.kind.to_sym, field.name, field.field_helper_options)
        end
      end
    end
    
    def link_to_add_field(name, f, association, conatiner_id, subclass = nil)
      if subclass
        new_object = subclass.constantize.new
      else
        new_object = f.object.class.reflect_on_association(association).klass.new
      end
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render :partial => "forms/#{association.to_s.singularize}", :locals => {:f => builder} 
      end
      link_to_function(name, h("add_field(\"#{conatiner_id}\", \"#{association}\", \"#{escape_javascript(fields)}\")".html_safe))
    end
    
    def link_to_add_field_option(name, f, association)
      new_object = f.object.class.reflect_on_association(association).klass.new
      fields = f.fields_for(association, new_object, :child_index => "new_#{association}") do |builder|
        render :partial => "forms/#{association.to_s.singularize}", :locals => {:f => builder} 
      end
      link_to_function(name, h("add_field_option(this, \"#{association}\", \"#{escape_javascript(fields)}\")".html_safe))
    end
    
    def link_to_remove_field(name, f)
      f.hidden_field(:_destroy) + link_to_function(name, "remove_field(this)")
    end
    
    def link_to_remove_field_option(name, f)
      f.hidden_field(:_destroy) + link_to_function(name, "remove_field_option(this)")
    end
    
  end
end
