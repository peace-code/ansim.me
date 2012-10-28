Goodclinic::Application.routes.draw do

  resources :hospitals
  resources :places

  get "maps/hospitals", as: 'hospital_map'
  get "maps/aeds", as: 'aed_map'

  get "pages/comments"
  get "pages/about"
  get "pages/other"

  root :to => 'maps#hospitals'
end