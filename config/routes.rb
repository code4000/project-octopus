Rails.application.routes.draw do
  devise_for :users

  root to: 'home#index'

  # TODO: limit only to used actions!
  resources :sites do
    resources :comments
    collection do
      get 'search'
    end
  end
  resources :students do
    resources :comments
    collection do
      get 'search'
    end
    collection { post :import }
  end
  resources :contacts do
    resources :comments
    collection do
      get 'search'
    end
    collection { post :import }
  end
  resources :user_accounts
  resources :comments

  post '/sites/new', to: 'sites#create'
  post '/students/new', to: 'students#create'
  post '/contacts/new', to: 'contacts#create'
  post '/user_accounts/new', to: 'user_accounts#create'
end
