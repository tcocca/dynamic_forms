# Models a radio button set
module DynamicForms
  module Models
    module FieldTypes
      module RadioButtonSelect
        
        def self.included(model)
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            acts_as_selector
            
            allow_validation_of :required
          end
        end
        
        module InstanceMethods
          def field_helper_options
            options = super
            options[:required] = self.required?
            options
          end
          
          def field_helper_select_options
            self.form_field_options.map &:label
          end
        end
        
      end
    end
  end
end
