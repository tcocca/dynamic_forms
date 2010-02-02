# The FormFieldOption models a single option for a <select> or radio button input.
module DynamicForms
  module Models
    module FormFieldOption
      
      def self.included(model)
        model.extend(ClassMethods)
        
        model.send(:include, InstanceMethods)
        model.send(:include, Relationships)
        
        model.class_eval do
          before_save :set_value_to_label
        end
      end
      
      module Relationships
        def self.included(model)
          model.class_eval do
            belongs_to :form_field, 
                       :class_name => "::FormField"
          end
        end
      end
      
      module InstanceMethods
        # for now, option labels and values will be the same
        def set_value_to_label
          self.value = self.label
        end
      end
      
      module ClassMethods
        
      end
      
    end
  end
end
