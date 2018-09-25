Rails.application.routes.draw do
  # Dashboard
  get 'dashboard', to: 'dashboard#index', as: 'dashboard'

  # Web console
  get 'console', to: 'console#show', as: 'console'

  # Sessions
  get    'login',    to: 'sessions#new', as: 'login'
  post   'sessions', to: 'sessions#create', as: 'sessions'
  delete 'logout',   to: 'sessions#destroy', as: 'logout'

  # Profiles
  get   'profile', to: 'profiles#edit', as: 'profile'
  patch 'profile', to: 'profiles#update'

  # Issues board
  get    'issues/board',             to: 'issues/board#index', as: 'issues_board'
  post   'issues/board',             to: 'issues/board#create'
  patch  'issues/board',             to: 'issues/board#update'
  delete 'issues/board',             to: 'issues/board#destroy'
  delete 'issues/board/empty',       to: 'issues/board#empty', as: 'empty_issues_board'
  delete 'issues/board/destroy_all', to: 'issues/board#destroy_all', as: 'issues_board_destroy_all'

  # Issues data export
  post   'issues/exports',     to: 'issues/exports#create'

  # Resources
  resources :comments, except: [:index, :new]
  resources :databases
  resources :descriptors
  resources :ldaps
  resources :rules
  resources :servers
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :issues, except: [:new, :create] do
    resources :taggings, only: [:new, :create, :destroy]
  end

  resources :permalinks, only: [:show, :create] do
    resources :issues, only: [:show]
  end

  namespace :rules do
    get 'imports/new'
    post 'imports/create'
    post 'exports/create'
  end

  resources :schedules do
    post   :run,     on: :member, as: :run
    delete :cleanup, on: :member, as: :cleanup

    resources :runs, shallow: true, only: [:index, :show, :destroy]
  end

  namespace :scripts do
    get 'imports/new'
    post 'imports/create'
    post 'exports/create'
  end

  resources :scripts do
    resources :issues,   only: [:index]
    resources :versions, only: [:index, :show], controller: 'scripts/versions'
  end

  namespace :users do
    resources :imports, only: [:new, :create]
  end

  resources :users

  scope ':kind', kind: /script|user|issue/ do
    resources :tags
  end

  get 'private/:path', to: 'files#show', constraints: { path: /.+/ }

  root 'sessions#new'
end
