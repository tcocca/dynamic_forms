# Models a TextArea
module DynamicForms
  module Models
    module FormField
      module TextArea

        def self.included(model)
          model.extend(ClassMethods)

          model.send(:include, InstanceMethods)
          
          allow_validation_of :required, :min_length, :max_length
        end

        module InstanceMethods
        
        end

        module ClassMethods
        
        end

      end
    end
  end
end
