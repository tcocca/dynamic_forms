# Models a TextField
class FormField::TextField < FormField
  allow_validation_of :required, :number, :min_length, :max_length
end