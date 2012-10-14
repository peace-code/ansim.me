Goodclinic::Application.routes.draw do
  resources :hospitals

  get "pages/home", as: 'map'
  get "pages/comments"
  get "pages/about"

  root :to => 'pages#home'
end