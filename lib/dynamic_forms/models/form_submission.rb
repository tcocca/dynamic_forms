# FormSubmission relies on its related Form and FormFields to give context to this data.
module DynamicForms
  module Models
    module FormSubmission
      
      def self.included(model)
        model.extend(ClassMethods)
        
        model.send(:include, InstanceMethods)
        model.send(:include, Relationships)
        
        model.class_eval do
          serialize :data, Hash
          
          alias_method_chain :valid?, :dynamic_validation
        end
      end
      
      module Relationships
        def self.included(model)
          model.class_eval do
            belongs_to :form, 
                       :class_name => "::Form"
            
            has_many :form_fields,
                     :class_name => "::FormField", 
                     :through => :form
          end
        end
      end
      
      module InstanceMethods
        def after_initialize
          self.data ||= {}
        end
        
        def field_keys
          self.form ? self.form.form_fields.map(&:name) : []
        end
        
        def valid_with_dynamic_validation?
          valid_without_dynamic_validation?
          self.form.form_fields.each { |ff| ff.validate_submission(self) }
          return self.errors.blank?
        end
        
        # Developed by Chris Powers, Killswitch Collective on 10/22/2008
        #
        # <b>Description:</b> Loop through the fields and easily access the value
        #
        # <em>Syntax: @form_submission.each_field do |field, value|</em>
        def each_field
          self.form.form_fields.each do |field|
            yield field, self.data[field.name.to_sym]
          end
        end
        
        private
        
        # Setup accessor to attach #data[:field_key] to #data.field_key
        # for both setters and getters.
        # --
        # Author:: Jacob Basham & Chris Powers, Killswitch Collective
        # ++
        def method_missing(method_name, *args, &block)
          name = method_name.to_s
          
          if field_keys.include? name.gsub(/=/, '')
            return name.include?("=") ? self.data[name.gsub(/=/, '').to_sym] = args.first : self.data[method_name]
          else
            logger.debug("Form is #{form} and the fields are #{self.form.form_fields if self.form}")
            super
          end
        end
      end
      
      module ClassMethods
        
      end
      
    end
  end
end
