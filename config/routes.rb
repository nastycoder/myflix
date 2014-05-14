Myflix::Application.routes.draw do

  root to: 'pages#front'

  resources :videos, only: :show do
    collection do
      get 'search' => :search
    end
  end

  resources :categories

  resources :users, only: :create
  resources :sessions, only: :create

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

  controller :sessions do
    get 'sign_in' => :new
    get 'sign_out' => :destroy
  end
end
