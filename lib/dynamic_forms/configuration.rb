module DynamicForms
  
  class << self
    attr_accessor :configuration
  end
  
  def self.configure
    self.configuration ||= Configuration.new
  end
  
  class Configuration
    attr_accessor :mailer_sender, :field_types, :validation_types, :valid_mime_types
    
    def initialize
      @mailer_sender = 'no-reply@example.com'
      @field_types = %w{text_field text_area select check_box check_box_group file_field radio_button_select time_select date_select datetime_select}
      @validation_types = %w{required? number? max_length min_length zip_code? email? phone_number? url? confirmed? mime_types time date datetime}
      @valid_mime_types = [
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
    end
  end
  
end
