# Models a form check_box
module DynamicForms
  module Models
    module FieldTypes
      module CheckBox
        
        def self.included(model)
          model.class_eval do
            allow_validation_of :confirmed
          end
        end
        
      end
    end
  end
end
