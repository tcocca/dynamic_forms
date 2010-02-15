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
          
          attr_accessor :datetime_temps
          
          alias_method_chain :valid?, :dynamic_validation
          
          before_validation :set_datetime_values
          
          before_save :save_file_uploads
        end
      end
      
      module Relationships
        def self.included(model)
          model.class_eval do
            belongs_to :form, 
                       :class_name => "::Form"
            
            belongs_to :submitter, :polymorphic => true
            
            has_many :form_fields,
                     :class_name => "::FormField", 
                     :through => :form
          end
        end
      end
      
      module InstanceMethods
        def after_initialize
          self.data ||= {}
          self.datetime_temps ||= []
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
        
        def set_datetime_values
          multi_param_attributes = assign_multiparameter_attributes(datetime_temps)
          multi_param_attributes.each do |field_name, value|
            self.data[field_name.to_sym] = value
          end
        end
        
        # After the submission has passed validation, 
        # write files to the filesystem and 
        # set the value for the file_field answer to be the path to the file 
        def save_file_uploads
          each_field do |field, value|
            if field.is_a?(::FormField::FileField) && !field.answer.blank?
              field.process_upload
              self.send("#{field.name}=".to_sym, field.file_name)
            end
          end
        end
        
        # Very simplified version of the ActiveRecord::Base method that handles only dates/times
        def execute_callstack_for_multiparameter_attributes(callstack)
          attributes = {}
          callstack.each do |name, values|
            if values.empty?
              send(name + '=', nil)
            else
              value = case values.size
                when 2
                  t = Time.new
                  no_blank_values?(values) ? Time.local(t.year, t.month, t.day, values[0], values[1], 0, 0) : nil
                when 5
                  no_blank_values?(values) ? DateTime.new(*values) : nil
                when 3
                  no_blank_values?(values) ? Date.new(*values) : nil
                else 
                  nil
              end
              attributes[name.to_s] = value
            end
          end
          attributes
        end
        
        # Check for any blank values in the array
        def no_blank_values?(values)
          values.each do |val|
            return false if val.blank?
          end
          return true
        end
        
        # Setup accessor to attach #data[:field_key] to #data.field_key
        # for both setters and getters.
        # --
        # Author:: Jacob Basham & Chris Powers, Killswitch Collective
        # ++
        def method_missing(method_name, *args, &block)
          name = method_name.to_s
          
          if field_keys.include? name.gsub('=', '').gsub(/\(\di\)/, '')
            if name.include?("=")
              if name.include?("(")  # if it is a multi_param field (time, datetime, date)
                datetime_temps << [name.to_s, args.first]
              else
                self.data[name.gsub('=', '').to_sym] = args.first
              end
            else
              self.data[method_name]
            end
          else
            logger.debug("Form is #{self.form.name if self.form} and the fields are #{self.form.form_fields if self.form}")
            super
          end
        end
      end
      
      module ClassMethods
        
      end
      
    end
  end
end
