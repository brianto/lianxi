Lianxi::Application.routes.draw do
  root :to => "home#index"
  
  get "/about" => "home#about"

  post "/login" => "home#login"
  post "/logout" => "home#logout"

  concern :quizable do
    member do
      get :grid
      get :quiz
    end

    resources :flash_cards, :only => [:create] do
      resources :examples, :only => [:create]
    end
  end

  resources :drills, :concerns => :quizable

  resources :songs, :concerns => :quizable do
    resources :lyrics, :only => [:create]
  end

  resources :passages, :concerns => :quizable do
    resources :articles, :only => [:create]
  end

  resources :flash_cards, :examples, :lyrics, :articles,
    :only => [:update, :destroy]

  resources :users
end
