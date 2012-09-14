Goodclinic::Application.routes.draw do
  resources :hospitals

  get "pages/home"
  get "pages/comments"

  root :to => 'pages#home'
end
