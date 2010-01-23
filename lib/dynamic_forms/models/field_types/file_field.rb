# Models a TextField
module DynamicForms
  module Models
    module FieldTypes
      module FileField
        
        VALID_MIME_TYPES = [
          "image/jpg",
          "image/jpeg",
          "image/pjpeg",
          "image/gif",
          "image/png",
          "application/msword",
          "application/pdf",
          "application/excel",
          "application/vnd.ms-excel",
          "application/x-excel",
          "application/x-msexcel"
        ]
        
        def self.included(model)
          model.extend(ClassMethods)
          
          model.send(:include, InstanceMethods)
          
          model.class_eval do
            attr_accessor :file_name
            
            allow_validation_of :required, :mime_types
          end
        end
        
        module InstanceMethods
          
          def validate_mime_types
            if !answer.blank? && !is_valid_mime_type?
              add_error_to_submission(" is an invalid file type.")
            end
          end
          
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
          
          def is_valid_mime_type?
            if !mime_types.blank?
              mime_types.split(',').collect{|mt| mt.strip}.include?(answer.content_type.strip)
            else
              VALID_MIME_TYPES.include?(answer.content_type.strip)
            end
          end
          
          def check_path(timestamp)
            base_dir = RAILS_ROOT + "/public/dynamic_forms"
            Dir.mkdir(base_dir, 0775) unless File.exists?(base_dir)
            forms_dir = base_dir + "/#{self.form_id}"
            Dir.mkdir(forms_dir, 0775) unless File.exists?(forms_dir)
            timestamp_dir = forms_dir + "/#{timestamp}"
            Dir.mkdir(timestamp_dir, 0775) unless File.exists?(timestamp_dir)
            timestamp_dir
          end
          
          def sanitize_filename(filename)
            # NOTE: File.basename doesn't work right with Windows paths on Unix
            # get only the filename, not the whole path
            # Replace all non alphanumeric, underscore
            # or periods with underscore
            #Downcase the whole string
            filename.strip.gsub(/^.*(\\|\/)/, '').gsub(/[^\w\.\-]/, '_').downcase
          end
          
        end
        
        module ClassMethods
          
        end
        
      end
    end
  end
end
