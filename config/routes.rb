Rails.application.routes.draw do
  resources :descriptors
  # Sessions
  get 'login', to: 'sessions#new', as: 'login'
  post 'sessions', to: 'sessions#create', as: 'sessions'
  delete 'logout', to: 'sessions#destroy', as: 'logout'

  # Profiles
  get 'profile', to: 'profiles#edit', as: 'profile'
  patch 'profile', to: 'profiles#update'

  # Resources
  resources :databases
  resources :issues, except: [:new, :create]
  resources :ldaps
  resources :rules
  resources :scripts
  resources :servers
  resources :tags
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :schedules do
    post :run, on: :member, as: :run

    resources :runs, shallow: true, only: [:index, :show, :destroy]
  end

  namespace :users do
    resources :imports, only: [:new, :create]
  end

  resources :users

  root 'sessions#new'
end
