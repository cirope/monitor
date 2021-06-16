# frozen_string_literal: true

Rails.application.routes.draw do
  # Home
  get 'home', to: 'home#index', as: 'home'

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
  post   'issues/exports',           to: 'issues/exports#create'

  # Resources
  resources :comments, except: [:index, :new]
  resources :databases
  resources :descriptors
  resources :ldaps
  resources :rules
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :accounts, except: [:destroy] do
    resources :issues, only: [:show]
    resources :permalinks, only: [:show]
    resources :password_resets, only: [:edit]
    resources :scripts, only: [:show] do
      resources :issues, only: [:index]
    end
  end

  # Dashboards
  resources :series, only: [:index, :show]
  resources :dashboards do
    resources :panels, except: [:index, :show]
  end

  resources :issues, except: [:new, :create] do
    resources :taggings, only: [:new, :create, :destroy]
  end

  resources :memberships, only: [:index, :update] do
    resources :switch, only: [:create], controller: 'memberships/switch'
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

    resources :runs, shallow: true, only: [:index, :show, :update, :destroy]
  end

  namespace :scripts do
    get 'imports/new'
    post 'imports/create'
    post 'exports/create'
  end

  resources :scripts do
    resources :issues,   only: [:index]
    resources :versions, only: [:index, :show], controller: 'scripts/versions'
    resources :executions, only: [:index, :create, :update, :show]
    resources :reverts, only: [:create], controller: 'scripts/reverts'

    scope ':type', type: /execution|run/ do
      resources :measures, only: [:index], controller: 'scripts/measures'
    end
  end

  resources :servers do
    resource :default, only: :update, controller: 'servers/default'
  end

  namespace :users do
    resources :imports, only: [:new, :create]
  end

  resources :users

  scope ':kind', kind: /script|user|issue/ do
    resources :tags
  end

  resources :processes, only: [:index, :destroy]

  root 'sessions#new'
end
