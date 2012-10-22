Goodclinic::Application.routes.draw do
  resources :hospitals

  get "maps/hospitals", as: 'hospital_map'

  get "pages/comments"
  get "pages/about"

  root :to => 'maps#hospitals'
end