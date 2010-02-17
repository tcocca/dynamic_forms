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
          
          def validate_date
            if !answer.blank? && !is_valid_date?
              add_error_to_submission(I18n.t(:date_select_error, :scope => [:dynamic_forms, :validations]))
            end
          end
          
          private
          
          def is_valid_date?
            Date.parse(answer.to_s)
          end
          
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end
