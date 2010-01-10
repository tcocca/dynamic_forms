# Models a TextArea
module DynamicForms
  module Models
    module FieldTypes
      module TextArea
        
        def self.included(model)
          model.extend(ClassMethods)
          
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            allow_validation_of :required, :min_length, :max_length
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
