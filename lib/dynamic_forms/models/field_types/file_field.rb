# Models a TextField
module DynamicForms
  module Models
    module FieldTypes
      module FileField
        
        def self.included(model)
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            attr_accessor :file_name
            
            allow_validation_of :required, :mime_types
          end
        end
        
        module InstanceMethods
          
          def process_upload
            unless answer.blank?
              timestamp = Time.now.to_i
              filename = sanitize_filename(answer.original_filename)
              path = check_path(timestamp) + "/" + filename
              File.open(path, "wb", 0664) do |fp|
                FileUtils.copy_stream(self.answer, fp)
              end
              self.file_name = "/dynamic_forms/#{self.form_id}/#{timestamp}/#{filename}"
            end
          end
          
          private
          
          def check_path(timestamp)
            base_dir = Rails.root + "/public/dynamic_forms"
            Dir.mkdir(base_dir, 0775) unless File.exists?(base_dir)
            forms_dir = base_dir + "/#{self.form_id}"
            Dir.mkdir(forms_dir, 0775) unless File.exists?(forms_dir)
            timestamp_dir = forms_dir + "/#{timestamp}"
            Dir.mkdir(timestamp_dir, 0775) unless File.exists?(timestamp_dir)
            timestamp_dir
          end
          
          # NOTE: File.basename doesn't work right with Windows paths on Unix
          # get only the filename, not the whole path
          # Replace all non alphanumeric, underscore
          # or periods with underscore
          # Downcase the whole string
          # Prepend the form_field.id on the front to fix issue with multiple file_fields in a form with the same file_name uploaded.
          def sanitize_filename(filename)
            "#{self.id}_" + filename.strip.gsub(/^.*(\\|\/)/, '').gsub(/[^\w\.\-]/, '_').downcase
          end
          
        end
        
      end
    end
  end
end
