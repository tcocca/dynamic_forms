# Models a TextField
module DynamicForms
  module Models
    module FormField
      module TextField
        
        def self.included(model)
          model.extend(ClassMethods)
          
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            allow_validation_of :required, :number, :min_length, :max_length
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
