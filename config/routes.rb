Rails.application.routes.draw do
	resources :forms, :controller => 'dynamic_forms/forms' do
		resources :form_submissions,
          :controller => "dynamic_forms/form_submissions",
          :only => [:index, :show, :new, :create]
	end
end