Goodclinic::Application.routes.draw do
  resources :hospitals

  get "pages/home", as: 'map'
  get "pages/comments"

  root :to => 'pages#home'
end
