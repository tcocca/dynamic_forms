# Models a TextField
module DynamicForms
  module Models
    module FieldTypes
      module TextField
        
        def self.included(model)
          model.extend(ClassMethods)
          
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            allow_validation_of :required, :number, :min_length, :max_length, :email, :zip_code, :phone_number, :url
          end
        end
        
        module InstanceMethods
          
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end
