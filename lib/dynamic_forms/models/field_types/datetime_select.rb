module DynamicForms
  module Models
    module FieldTypes
      module DatetimeSelect
        
        def self.included(model)
          model.extend(ClassMethods)
          
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
          
          def validate_datetime
            if !answer.blank? && !is_valid_datetime?
              add_error_to_submission(" is an invalid date & time.")
            end
          end
          
          private
          
          def is_valid_datetime?
            DateTime.parse(answer.to_s)
          end
          
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end
