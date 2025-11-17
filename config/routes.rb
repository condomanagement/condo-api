# frozen_string_literal: true

Rails.application.routes.draw do
  Healthcheck.routes(self)
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Version endpoint - publicly accessible
  get "/version", to: "version#show"

  # Define routes without /api prefix for backwards compatibility (Azure strips /api)
  resources :authentications
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

  # Authentication routes
  scope :authentication do
    post "login", to: "authentications#login"
    post "process_login", to: "authentications#process_login"
    post "valid", to: "authentications#valid"
    post "logout", to: "authentications#logout"
  end

  # Email magic link verification
  get "/authenticate/:emailKey", to: "authentications#process_login"

  # WebAuthn/Passkey routes
  scope :webauthn do
    get "registration_options", to: "webauthn_credentials#registration_options", as: "webauthn_registration_options"
    post "register", to: "webauthn_credentials#register", as: "webauthn_register"
    get "authentication_options", to: "webauthn_credentials#authentication_options",
                                  as: "webauthn_authentication_options"
    post "authenticate", to: "webauthn_credentials#authenticate", as: "webauthn_authenticate"
    get "credentials", to: "webauthn_credentials#index", as: "webauthn_credentials"
    delete "credentials/:id", to: "webauthn_credentials#destroy", as: "webauthn_credential"
    patch "credentials/:id", to: "webauthn_credentials#update", as: "webauthn_credential_update"
    get "check_availability", to: "webauthn_credentials#check_availability", as: "webauthn_check_availability"
  end

  # Also define the same routes under /api for direct API access
  scope :api do
    resources :authentications
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
      patch "approve/:id", to: "elevator_bookings#approve", as: "api_elevator_booking_approve"
      patch "reject/:id", to: "elevator_bookings#reject", as: "api_elevator_booking_reject"
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

    # Authentication routes
    scope :authentication do
      post "login", to: "authentications#login"
      post "process_login", to: "authentications#process_login"
      post "valid", to: "authentications#valid"
      post "logout", to: "authentications#logout"
    end

    # Email magic link verification
    get "/authenticate/:emailKey", to: "authentications#process_login"

    # WebAuthn/Passkey routes
    scope :webauthn do
      get "registration_options", to: "webauthn_credentials#registration_options",
                                  as: "api_webauthn_registration_options"
      post "register", to: "webauthn_credentials#register", as: "api_webauthn_register"
      get "authentication_options", to: "webauthn_credentials#authentication_options",
                                    as: "api_webauthn_authentication_options"
      post "authenticate", to: "webauthn_credentials#authenticate", as: "api_webauthn_authenticate"
      get "credentials", to: "webauthn_credentials#index", as: "api_webauthn_credentials"
      delete "credentials/:id", to: "webauthn_credentials#destroy", as: "api_webauthn_credential"
      patch "credentials/:id", to: "webauthn_credentials#update", as: "api_webauthn_credential_update"
      get "check_availability", to: "webauthn_credentials#check_availability", as: "api_webauthn_check_availability"
    end
  end
end
