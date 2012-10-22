Goodclinic::Application.routes.draw do
  resources :hospitals

  get "maps/hospitals", as: 'hospital_map'

  get "pages/comments"
  get "pages/about"
  get "pages/other"

  root :to => 'maps#hospitals'
end