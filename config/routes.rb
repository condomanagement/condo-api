# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  scope :api do
    resources :parking
    resources :users
    scope :users do
      post "upload", to: "users#upload"
    end
  end
end
