module DynamicForms
  
  class Routes
    # If you need to override a DynamicForm route, add your route above the DynamicForms::Routes.draw(map) definition
    # rails will read your route definition first and ignore the definition defined by the dynamic forms routes draw method 
    #
    # @example
    #   map.resources :forms, :only => [:new, :create]
    #   DynamicForm::Routes.draw(map)
    def self.draw(map)
      map.resources :forms, :controller => 'dynamic_forms/forms' do |forms|
        forms.resources :form_submissions,
          :controller => "dynamic_forms/form_submissions",
          :only => [:index, :show, :new, :create]
      end
    end
  end
  
end
