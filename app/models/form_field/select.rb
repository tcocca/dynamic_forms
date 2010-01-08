# Models a select drop-down input
class FormField::Select < FormField
  
  acts_as_selector
  allow_validation_of :required  
  
  def select_options
    self.form_field_options.map {|ffo| [ffo.label, ffo.value]}
  end
  
end