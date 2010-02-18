# Models a TextArea
module DynamicForms
  module Models
    module FieldTypes
      module TextArea
        
        def self.included(model)
          model.class_eval do
            allow_validation_of :required, :min_length, :max_length
          end
        end
        
      end
    end
  end
end
