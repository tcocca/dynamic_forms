# Models a habtm checkbox group
class FormField::CheckBoxGroup < FormField
  
  acts_as_selector
  has_many_responses
  allow_validation_of :required
  
  def check_box_group_collection
    self.form_field_options.map &:label
  end
  
end