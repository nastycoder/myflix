Myflix::Application.routes.draw do

  root to: 'pages#front'

  resources :videos, only: :show do
    collection do
      get 'search' => :search
    end
    resources :reviews, only: :create
  end

  resources :categories

  resources :users, only: [:create, :show]
  resources :sessions, only: :create
  resources :queue_items, only: [:create, :destroy]
  resources :following, only: [:destroy]

  get 'ui(/:action)', controller: 'ui'

  controller :queue_items do
    get 'my_queue' => :index
    put 'queue_update' => :batch_update
  end

  controller :categories do
    get 'genre' => :index
  end

  controller :videos do
    get 'home' => :index
  end

  controller :users do
    get 'register' => :new
  end

  controller :following do
    get 'people' => :index
  end

  controller :sessions do
    get 'sign_in' => :new
    get 'sign_out' => :destroy
  end
end
