Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "pages#home"

  resource :session, only: %i[create destroy]
  get "dashboard", to: "dashboards#show"

  resources :mentors, only: %i[index show]
  resources :bookings, only: %i[create show] do
    member do
      get :success
    end
    resource :room, only: :show, controller: "session_rooms"
  end

  namespace :mentor do
    get "dashboard", to: "dashboards#show"
    resource :profile, only: %i[new create edit update]
    resources :slots, only: %i[create destroy]
  end

  post "stripe/webhook", to: "stripe_webhooks#create"

  if Rails.env.development?
    post "dev_login/:id", to: "dev_sessions#create", as: :dev_login
  end
end
