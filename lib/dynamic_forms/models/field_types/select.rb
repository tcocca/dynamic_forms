# Models a select drop-down input
module DynamicForms
  module Models
    module FieldTypes
      module Select
        
        def self.included(model)
          model.extend(ClassMethods)
          
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            acts_as_selector
            allow_validation_of :required
          end
        end
        
        module InstanceMethods
          def select_options
            self.form_field_options.map {|ffo| [ffo.label, ffo.value]}
          end
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end
