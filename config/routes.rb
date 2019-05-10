Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  # TODO: limit onbly to used actions!
  resources :sites
  post '/sites/new', to: 'sites#create'
  resources :students
  post '/students/new', to: 'students#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
