module DynamicForms
  module Models
    module FieldTypes
      module DatetimeSelect
        
        def self.included(model)
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            allow_validation_of :required, :datetime
          end
        end
        
        module InstanceMethods
          def field_helper_options
            options = super
            options[:prompt] = true
            options[:twelve_hour] = true
            options
          end
          
          def field_helper_html_options
            {}
          end
        end
        
      end
    end
  end
end
