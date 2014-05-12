Myflix::Application.routes.draw do
  resources :videos
  get 'ui(/:action)', controller: 'ui'

  controller :videos do
    get 'home' => :index
  end
end
