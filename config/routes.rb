# frozen_string_literal: true

Rails.application.routes.draw do
  resources :authentications
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api do
    scope :reservations do
      get "mine", to: "reservations#mine"
      post "create", to: "reservations#create"
      post "find_reservations", to: "reservations#find_reservations"
      delete "destroy/:id", to: "reservations#destroy"
    end
    resources :reservations

    resources :questions
    scope :questions do
      post "create", to: "questions#create"
      delete "destroy/:id", to: "questions#destroy"
    end
    resources :resources
    scope :resources do
      post "create", to: "resources#create"
      delete "destroy/:id", to: "resources#destroy"
    end
    scope :parking do
      post "create", to: "parking#create"
      delete "destroy/:id", to: "parking#destroy"
      get "today", to: "parking#today"
      get "past", to: "parking#past"
      get "future", to: "parking#future"
    end
    resources :parking

    resources :users
    scope :users do
      post "upload", to: "users#upload"
    end
    scope :authentication do
      post "login", to: "authentications#login"
      post "process_login", to: "authentications#process_login"
      post "valid", to: "authentications#valid"
      post "logout", to: "authentications#logout"
    end
  end
end
