Lianxi::Application.routes.draw do
  root :to => "home#index"
  
  get "/about" => "home#about"

  post "/login" => "home#login"
  post "/logout" => "home#logout"

  concern :teachable do
    member do
      get :grid
      get :quiz
      get :difficulties, :action => :get_difficulties
      post :difficulties, :action => :update_difficulties

      get :pin, :action => :get_pin
      post :pin, :action => :toggle_pin
    end

    resources :flash_cards, :only => [:create] do
      resources :examples, :only => [:create]
    end
  end

  resources :drills, :concerns => :teachable

  resources :songs, :concerns => :teachable do
    resources :lyrics, :only => [:create]
  end

  resources :passages, :concerns => :teachable do
    resources :articles, :only => [:create]
  end

  resources :flash_cards, :examples, :lyrics, :articles,
    :only => [:update, :destroy]

  resources :users
end
