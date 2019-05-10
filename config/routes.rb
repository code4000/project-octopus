Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  # TODO: limit onbly to used actions!
  resources :sites
  resources :students
  resources :user_accounts
  post '/sites/new', to: 'sites#create'
  post '/students/new', to: 'students#create'
  post '/user_accounts/new', to: 'user_accounts#create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
