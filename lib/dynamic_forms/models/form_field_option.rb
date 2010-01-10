# The FormFieldOption models a single option for a <select> or radio button input.
module DynamicForms
  module Models
    module FormFieldOption

      def self.included(model)
        model.extend(ClassMethods)

        model.send(:include, InstanceMethods)
        model.send(:include, Relationships)
      end

      module Relationships
        def self.included(model)
          model.class_eval do
            belongs_to :form_field
          end
        end
      end

      module InstanceMethods
        
      end

      module ClassMethods
        
      end

    end
  end
end
