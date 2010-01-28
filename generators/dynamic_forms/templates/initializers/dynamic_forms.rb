DynamicForms.configure do |config|
  # configures the email address that forms will be sent from
  config.mailer_sender = 'no-reply@example.com'
  
  # configures the text that will be displayed when viewing a form submission for a field that was left blank 
  # defaults to '(no response)'
  # config.no_resonse = "(no response)"
  
  # configures the text that will be shown for a true answer to a check box field (box was checked)
  # defaults to 'Yes'
  # config.true_value = "Yes"
  
  # configures the text that will be shown for a false answer to a check box field (box was NOT checked)
  # defaults to 'No'
  # config.false_value = "No"
  
  # configures the field types that are available to be used in the dynamic forms
  # this is dependent on the FormField models
  # by default you should not have to change these values unless you add a custom field type
  # config.field_types = %w{text_field text_area select check_box check_box_group file_field}
  
  # configures the validation types that are available to be used on form fields
  # by default you should not have to change these values unless you add a custom validation type
  # config.validation_types = %w{required? number? max_length min_length zip_code? email? phone_number? url? confirmed? mime_types}
  
  # configures to the default valid mime types for file field uploads
  # if you do not specify mime types on the form field directly the system will validate the upload against these default mime types
  # defaults are shown below
  # config.valid_mime_types = [
  #   "image/jpg",
  #   "image/jpeg",
  #   "image/pjpeg",
  #   "image/gif",
  #   "image/png",
  #   "application/msword",
  #   "application/pdf",
  #   "application/excel",
  #   "application/vnd.ms-excel",
  #   "application/x-excel",
  #   "application/x-msexcel"
  # ]
end
