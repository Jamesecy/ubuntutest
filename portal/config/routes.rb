Cenit::Application.routes.draw do
  resources :profiles

  mount RailsAdmin::Engine => '/data', as: 'rails_admin'
  use_doorkeeper

  root to: 'home#index'
  
  devise_for :users, controllers: { confirmations: 'confirmations' }

  devise_scope :user do
    # get 'users/sign_out', to: 'devise/sessions#destroy'
    put 'update_card', to: 'devise/registrations#update_card'
  end

  namespace :api do
    namespace :v1 do
      resources :status
      resources :users
      # resources :profiles, only: [:index, :create]
      resources :app_logs, only: [:index, :create]
      get '/me', to: 'credentials#me'
      # get '/fast' => 'fast#index'
    end
  end

  resources :blog, only: [:index, :new]
  resources :partnership, only: :index
  resources :cenithub, only: :index
  
  get '/about_us', to: 'about_us#index', as: 'about_us'
  get '/hub', to: 'hub#index', as: 'hub'
  get '/features', to: 'features#index', as: 'features'
  get '/api_references', to: 'api_references#index', as: 'api_references'
  get '/services', to: 'services#index', as: 'services'
  get '/status/:id', to: 'status#show', as: 'status'
end
