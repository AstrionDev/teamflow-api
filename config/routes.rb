Rails.application.routes.draw do
  if defined?(Rswag::Api::Engine) && defined?(Rswag::Ui::Engine)
    mount Rswag::Api::Engine => "/api-docs"
    mount Rswag::Ui::Engine => "/api-docs"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      post "auth/login", to: "auth#login"
      resources :users
      resources :notifications, only: [ :index, :show, :update ]
      resources :organizations do
        resources :memberships
        resources :audit_logs, only: [ :index ]
        resources :invitations, only: [ :index, :show, :create, :destroy ]
        resource :subscription, only: [ :show, :update ]
        resources :projects do
          resources :tasks
        end
      end
    end
  end
end
