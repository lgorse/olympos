Olympos::Application.routes.draw do

	root :to => 'sessions#new'

	resources :users do
		resources :friendships, only: [:friendships, :requests, :pending] do
			collection do
			 get :friendships, :requests, :pending
			end
		end
		
		member do
			get :details
			get :change_picture
		end
		get 'fb', on: :new
		collection do
			get :home
		end

	end

	resources :sessions, :conversations, :messages

	resources :invitations do
		collection do
			get :ussquash
		end
	end

	resources :friendships, only: [:index, :create, :destroy] do
		collection do
			post :accept

		end

	end

	

	match '/logout' => 'sessions#destroy'

end
