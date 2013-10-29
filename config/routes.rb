Olympos::Application.routes.draw do
  
root :to => 'sessions#new'

resources :users do
	member do
		get :details
	end
end

resources :sessions
	

match '/logout' => 'sessions#destroy'

end
