Goodclinic::Application.routes.draw do
  resources :hospitals

  get "pages/home", as: 'map'
  get "pages/comments"
  get "pages/about"
  get "pages/other"

  root :to => 'pages#home'
end