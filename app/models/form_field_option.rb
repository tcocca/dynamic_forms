# The FormFieldOption class models a single option for a <select> or radio button input.
class FormFieldOption < ActiveRecord::Base
  
  belongs_to :form_field
  
end
