# Models a habtm checkbox group
module DynamicForms
  module Models
    module FieldTypes
      module CheckBoxGroup
        
        def self.included(model)
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            acts_as_selector
            has_many_responses
            allow_validation_of :required
          end
        end
        
        module InstanceMethods
          def field_helper_select_options
            self.form_field_options.map &:label
          end
        end
        
      end
    end
  end
end
