Myflix::Application.routes.draw do

  root to: 'pages#front'

  namespace :admin do
    resources :videos, only: [:new, :create]
    resources :payments, only: [:index]
  end

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
  resources :relationships, only: [:create, :destroy]
  resources :forgot_password, only: :create
  resources :password_resets, only: [:show, :create]
  resources :invites, only: [:new, :create]

  get 'ui(/:action)', controller: 'ui'

  controller :pages do
    get 'expired_token' => :expired_token
  end

  controller :forgot_password do
    get 'forgot_password' => :new
    get 'forgot_password_confirmation' => :confirm
  end

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
    get 'register/:invite_token' => :new_from_invite, as: 'register_from_invite'
  end

  controller :relationships do
    get 'people' => :index
  end

  controller :sessions do
    get 'sign_in' => :new
    get 'sign_out' => :destroy
  end

  mount StripeEvent::Engine => '/stripe_events'
end
