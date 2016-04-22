Rails.application.routes.draw do
  # Dashboard
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

  # Sessions
  get    'login',    to: 'sessions#new', as: 'login'
  post   'sessions', to: 'sessions#create', as: 'sessions'
  delete 'logout',   to: 'sessions#destroy', as: 'logout'

  # Profiles
  get   'profile', to: 'profiles#edit', as: 'profile'
  patch 'profile', to: 'profiles#update'

  # Issues board
  get    'issues/board',       to: 'issues/board#index', as: 'issues_board'
  post   'issues/board',       to: 'issues/board#create'
  patch  'issues/board',       to: 'issues/board#update'
  delete 'issues/board',       to: 'issues/board#destroy'
  delete 'issues/board/empty', to: 'issues/board#empty', as: 'empty_issues_board'

  # Resources
  resources :databases
  resources :descriptors
  resources :issues, except: [:new, :create]
  resources :ldaps
  resources :rules
  resources :servers
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :permalinks, only: [:show, :create] do
    resources :issues, only: [:show]
  end

  resources :schedules do
    post :run, on: :member, as: :run
    delete :cleanup, on: :member, as: :cleanup

    resources :runs, shallow: true, only: [:index, :show, :destroy]
  end

  resources :scripts do
    resources :issues, only: [:index]
  end

  namespace :users do
    resources :imports, only: [:new, :create]
  end

  resources :users

  scope ':kind', kind: /script|user|issue/ do
    resources :tags
  end

  root 'sessions#new'
end
