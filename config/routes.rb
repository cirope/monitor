# frozen_string_literal: true

Rails.application.routes.draw do
  match '/404', to: 'errors#not_found',            via: :all
  match '/422', to: 'errors#unprocessable_entity', via: :all
  match '/500', to: 'errors#internal_error',       via: :all

  # Home
  get 'home',                      to: 'home#index', as: 'home'
  get 'home/api_issues_by_status', to: 'home#api_issues_by_status'

  # Web console
  get 'console', to: 'console#show', as: 'console'

  # Sessions
  get    'login',    to: 'sessions#new', as: 'login'
  post   'sessions', to: 'sessions#create', as: 'sessions'
  delete 'logout',   to: 'sessions#destroy', as: 'logout'

  # Authentication
  get  'signin', to: 'authentications#new',    as: 'signin'
  post 'auth',   to: 'authentications#create', as: 'auth'

  # DRIVE
  get 'drives/providers',        to: 'drives/providers#index'
  get 'drives/provider_options', to: 'drives/providers#show'

  # SAML
  get  'saml/:tenant_name/auth',     to: 'saml_sessions#new',      as: :new_saml_session
  post 'saml/:tenant_name/callback', to: 'saml_sessions#create',   as: :saml_session
  get  'saml/:tenant_name/metadata', to: 'saml_sessions#metadata', as: :saml_metadata

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

  # Get Api script/issues
  post   'script/api_issues',        to: 'issues#api_issues'

  # Resources
  resources :databases
  resources :descriptors
  resources :drives
  resources :ldaps
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :pdf_templates
  resources :roles
  resources :rules do
    resources :reverts, only: [:create], controller: 'rules/reverts'
    resources :tickets do
      resources :comments, only: [:create], controller: 'tickets/comments'
    end

    resources :versions, only: [:index, :show], controller: 'rules/versions'
  end
  resources :samls

  # Tickets
  resources :tickets do
    scope module: 'tickets' do
      resources :comments, except: [:index, :new]
    end

    resources :scripts, only: [:new, :create, :show]
    resources :rules, only: [:new, :create, :show]
    resources :taggings, only: [:new, :create, :destroy]
  end

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

  resources :issues do
    scope module: 'issues' do
      resources :comments, except: [:index, :new]
    end
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

    scope module: 'schedules' do
      resources :jobs, only: [:update]
    end
  end

  namespace :scripts do
    get 'imports/new'
    post 'imports/create'
    post 'exports/create'
  end

  resources :scripts do
    resources :issues do
      resources :comments, only: [:create], controller: 'issues/comments'
    end
    resources :versions, only: [:index, :show], controller: 'scripts/versions'
    resources :parameters, only: [:show], controller: 'scripts/parameters'
    resources :executions, except: [:new, :edit] do
      delete :cleanup, on: :collection, as: :cleanup
    end
    resources :reverts, only: [:create], controller: 'scripts/reverts'
    resources :tickets do
      resources :comments, only: [:create], controller: 'tickets/comments'
    end

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

  scope ':kind', kind: /script|user|issue|ticket/ do
    resources :tags
  end

  resources :system_monitors, only: [:index, :destroy]

  scope ':kind', kind: /login|fail/ do
    resources :records, only: [:index, :show]
  end

  resources :views, only: [:create]

  namespace :api do
    namespace :v1 do
      resources :scripts, except: [:index, :show, :new, :create, :edit, :update, :destroy] do
        get 'issues', to: 'scripts/issues#index'
      end

      namespace :scripts do
        get 'issues_by_status', to: 'issues_by_status#index'
      end
    end
  end

  root 'sessions#new'
end
