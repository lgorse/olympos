Olympos::Application.routes.draw do
  
root :to => 'sessions#new'

resources :users do
	member do
		get :details
		get :change_picture
	end
	get 'fb', on: :new
	collection do
		get :home
	end
end

resources :sessions, :invitations
	

match '/logout' => 'sessions#destroy'

end
