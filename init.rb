require 'dynamic_forms'

config.to_prepare do
  ApplicationController.helper(DynamicForms::CheckBoxGroupHelper)
  ApplicationController.helper(DynamicForms::RadioButtonSelectHelper)
  ApplicationController.helper(DynamicForms::FormsHelper)
  ApplicationController.helper(DynamicForms::FormSubmissionsHelper)
end

ActiveRecord::Base.send(:include, DynamicForms::Relationships)

ActionView::Helpers::AssetTagHelper.register_javascript_expansion :dynamic_forms_prototype => [
 '/javascripts/dynamic_forms/dynamic_forms_prototype'
]
