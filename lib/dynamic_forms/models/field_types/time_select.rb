module DynamicForms
  module Models
    module FieldTypes
      module TimeSelect
        
        def self.included(model)
          model.extend(ClassMethods)
          
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            allow_validation_of :required, :time
          end
        end
        
        module InstanceMethods
          def field_helper_options
            options = super
            options[:prompt] = true
            options[:ignore_date] = true
            options[:twelve_hour] = true
            options
          end
          
          def validate_time
            if !answer.blank? && !is_valid_time?
              add_error_to_submission(" is an invalid time.")
            end
          end
          
          private
          
          def is_valid_time?
            Time.parse(answer.to_s)
          end
          
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end
