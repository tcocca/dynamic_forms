# Models a TextField
module DynamicForms
  module Models
    module FieldTypes
      module TextField
        
        def self.included(model)
          model.class_eval do
            allow_validation_of :required, :number, :min_length, :max_length, :email, :zip_code, :phone_number, :url
          end
        end
        
      end
    end
  end
end
