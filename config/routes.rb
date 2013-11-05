Olympos::Application.routes.draw do
  
root :to => 'sessions#new'

resources :users do
	member do
		get :details
		get :home
		get :change_picture
	end
	get 'fb', on: :new
end

resources :sessions
	

match '/logout' => 'sessions#destroy'

end
