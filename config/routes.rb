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
      patch "update/:id", to: "questions#update"
      delete "destroy/:id", to: "questions#destroy"
    end
    resources :resources
    scope :resources do
      post "create", to: "resources#create"
      patch "update/:id", to: "resources#update"
      delete "destroy/:id", to: "resources#destroy"
    end

    resources :resource_questions
    scope :resource_questions do
      post "create", to: "resource_questions#create"
      post "remove", to: "resource_questions#remove"
    end

    resources :elevator_bookings
    scope :elevator_bookings do
      post "create", to: "elevator_bookings#create"
      post "remove", to: "elevator_bookings#remove"
      patch "approve/:id", to: "elevator_bookings#approve", as: "elevator_booking_approve"
      patch "reject/:id", to: "elevator_bookings#reject", as: "elevator_booking_reject"
    end

    scope :parking do
      post "create", to: "parking#create"
      delete "destroy/:id", to: "parking#destroy"
      get "today", to: "parking#today"
      get "past", to: "parking#past"
      get "future", to: "parking#future"
    end
    resources :parking

    scope :users do
      post "upload", to: "users#upload"
      post "create", to: "users#create"
      patch "update/:id", to: "users#update"
    end
    resources :users

    scope :authentication do
      post "login", to: "authentications#login"
      post "process_login", to: "authentications#process_login"
      post "valid", to: "authentications#valid"
      post "logout", to: "authentications#logout"
    end
  end
end
