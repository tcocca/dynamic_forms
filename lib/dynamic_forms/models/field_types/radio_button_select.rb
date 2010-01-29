# Models a radio button set
module DynamicForms
  module Models
    module FieldTypes
      module RadioButtonSelect
        
        def self.included(model)
          model.extend(ClassMethods)
          
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            acts_as_selector
            
            allow_validation_of :required
          end
        end
        
        module InstanceMethods
          def radio_button_select_collection
            self.form_field_options.map &:label
          end
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end
