Myflix::Application.routes.draw do
  resources :videos
  get 'ui(/:action)', controller: 'ui'

  controller :categories do
    get 'genre' => :index
  end

  controller :videos do
    get 'home' => :index
  end
end
