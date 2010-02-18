module DynamicForms
  module Models
    module FieldTypes
      module DateSelect
        
        def self.included(model)
          model.extend(ClassMethods)
          
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            allow_validation_of :required, :date
          end
        end
        
        module InstanceMethods
          def field_helper_options
            options = super
            options[:prompt] = true
            options
          end
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end
