Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  resource :session, only: %i[create destroy]
  get "dashboard", to: "dashboards#show"

  resources :notifications, only: %i[index] do
    member do
      post :read
    end
    collection do
      post :read_all
    end
  end

  resources :mentors, only: %i[index show] do
    resource :favorite, only: %i[create destroy]
  end

  resources :bookings, only: %i[create show] do
    member do
      get :success
      get :ics
      post :cancel
      post :complete
    end
    resource :room, only: :show, controller: "session_rooms"
    resources :reviews, only: %i[create]
    resources :notes, only: %i[create], controller: "booking_notes"
  end

  namespace :mentor do
    get "dashboard", to: "dashboards#show"
    resource :profile, only: %i[new create edit update]
    resources :slots, only: %i[create destroy]
  end

  namespace :admin do
    root to: "dashboard#show"
    resources :users, only: %i[index]
    resources :bookings, only: %i[index]
    resources :mentor_profiles, only: %i[index update]
  end

  post "stripe/webhook", to: "stripe_webhooks#create"

  if Rails.env.local?
    post "dev_login/:id", to: "dev_sessions#create", as: :dev_login
  end
end
