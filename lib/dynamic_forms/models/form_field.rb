# The FormField is an abstract model of a field that is in a form. It holds information about
# naming, labelling, validation etc. for that field. It is subclassed for each kind of form field.
module DynamicForms
  module Models
    module FormField
      
      def self.included(model)
        model.extend(ClassMethods)
        
        model.send(:include, InstanceMethods)
        model.send(:include, Relationships)
        model.send(:include, Callbacks)
        model.send(:include, Validations)
        model.send(:include, DynamicForms::Extensions::DynamicValidations)
        
        model.class_eval do
          serialize :validations, Hash
          
          eval "serialized_validation_attr_accessor #{DynamicForms.configuration.validation_types.collect{|t| ":#{t}"}.join(', ')}"
          
          accepts_nested_attributes_for :form_field_options, :reject_if => lambda { |a| a[:label].blank? }, :allow_destroy => true
          
          attr_accessor :answer, :submission
        end
      end
      
      module Relationships
        def self.included(model)
          model.class_eval do
            belongs_to :form,
                       :class_name => "::Form"
            
            has_many :form_field_options, 
                     :class_name => "::FormFieldOption",
                     :order => 'position ASC, label ASC'
          end
        end
      end
      
      module Callbacks
        def self.included(model)
          model.class_eval do
            before_validation :assign_name
          end
        end
      end
      
      module Validations
        def self.included(model)
          model.class_eval do
            validates_presence_of :name
          end
        end
      end
      
      module InstanceMethods
        def validate_submission(form_submission)
          self.submission = form_submission
          self.answer = submission.send(name)
          
          DynamicForms.configuration.validation_types.each do |validation|
            validation_name = validation.gsub('?', '')
            self.send("validate_#{validation_name}".to_sym) if self.allow_validation_of?(validation_name.to_sym)
          end
        end
        
        def kind
          self.class.to_s.split("::").last.underscore
        end
        
        # needed for the nested_form
        # accepts_nested_attributes_for does not set the type correctly on STI and can't mass assign type
        def sti_type
          self.type
        end
        
        def sti_type=(sti_type)
          self.type = sti_type
        end
        
        # overridden by has_many_responses
        def has_many_responses?
          false
        end
        
        # overridden by acts_as_selector
        def is_selector?
          false
        end
        
        #overwritten by self.allow_validation_of
        def allow_validation_of?(sym)
          false
        end
        
        private
        
        def assign_name
          self.name = "field_" + Digest::SHA1.hexdigest(self.label + Time.now.to_s).first(20) if self.name.blank?
        end
      end
      
      module ClassMethods
        # indicates that the value of this field is an array of responses
        def has_many_responses
          define_method("has_many_responses?") { true }
        end
        
        # indicates there is a static set that can be used in a select, check_box_group, etc
        def acts_as_selector
          define_method("is_selector?") { true }
        end
        
        def allow_validation_of(*syms)
          define_method 'allow_validation_of?' do |sym|
            syms.include? sym
          end
        end
        
        def serialized_validation_attr_accessor(*args)
          args.each do |method_name|
            method_declaration = <<-METHOD
              def #{method_name.to_s.gsub('?', '')}
                validations[:#{method_name.to_s.gsub('?', '')}] if self.validations
              end
              def #{method_name.to_s.gsub('?', '')}=(value)
                self.validations = {} unless self.validations
                self.validations[:#{method_name.to_s.gsub('?', '')}] = value
              end
            METHOD
            class_eval method_declaration
            
            if method_name.to_s.end_with?('?')
              boolean_method_declaration = <<-METHOD
                def #{method_name.to_s}
                  if self.validations
                    validations[:#{method_name.to_s.gsub('?', '')}] && validations[:#{method_name.to_s.gsub('?', '')}] == "1"
                  else
                    false
                  end
                end
              METHOD
              class_eval boolean_method_declaration
            end
          end
        end
      end
      
    end
  end
end
