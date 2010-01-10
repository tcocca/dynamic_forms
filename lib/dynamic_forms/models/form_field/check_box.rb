# Models a form check_box
module DynamicForms
  module Models
    module FormField
      module CheckBox
        
        def self.included(model)
          model.extend(ClassMethods)
          
          model.send(:include, InstanceMethods)
        end
        
        module InstanceMethods
          
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end
