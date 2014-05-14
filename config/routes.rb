Myflix::Application.routes.draw do

  root to: 'pages#front'

  get 'sign_in' => 'sessions#new'

  resources :videos, only: :show do
    collection do
      get 'search' => :search
    end
  end

  resources :categories

  resources :users, only: :create

  get 'ui(/:action)', controller: 'ui'

  controller :categories do
    get 'genre' => :index
  end

  controller :videos do
    get 'home' => :index
  end

  controller :users do
    get 'register' => :new
  end
end
