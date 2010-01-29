require 'dynamic_forms'

config.to_prepare do
  ApplicationController.helper(DynamicForms::CheckBoxGroupHelper)
  ApplicationController.helper(DynamicForms::RadioButtonSelectHelper)
  ApplicationController.helper(DynamicForms::FormSubmissionsHelper)
end
