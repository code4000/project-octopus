Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  # TODO: limit onbly to used actions!
  resources :sites do
    post :add_regions, on: :collection
    post :add_tags, on: :collection
  end
  resources :students do
    post :add_skills, on: :collection
    post :add_job_preferences, on: :collection
    post :add_tags, on: :collection
  end
  resources :user_accounts
  
  post '/sites/new', to: 'sites#create'
  post '/students/new', to: 'students#create'
  post '/user_accounts/new', to: 'user_accounts#create'
end
