Myflix::Application.routes.draw do

  resources :videos, only: :show do
    collection do
      get 'search' => :search
    end
  end

  resources :categories

  get 'ui(/:action)', controller: 'ui'

  controller :categories do
    get 'genre' => :index
  end

  controller :videos do
    get 'home' => :index
  end
end
