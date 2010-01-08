# Models a TextArea
class FormField::TextArea < FormField
  allow_validation_of :required, :min_length, :max_length
end