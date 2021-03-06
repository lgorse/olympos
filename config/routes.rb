Olympos::Application.routes.draw do

  root :to => 'sessions#new'

  resources :sessions, :conversations, :messages, :clubs

  resources :users do
    collection do
      get :map, :search, :about_skill
    end
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

    resources :matches, only: [:index, :update]

  end


  resources :invitations do
    collection do
      get :ussquash
    end
  end

  resources :friendships, only: [:index, :create, :destroy] do
    collection do
      post :accept
    end
    member do
      delete :reject
    end
  end

  resources :matches, except: [:index, :update]

  resources :fairness_ratings do
    collection do
      get :about
    end
  end

  match '/logout' => 'sessions#destroy'

  if Rails.env.development?
    mount MailPreview => 'mail_view'
  end

end
