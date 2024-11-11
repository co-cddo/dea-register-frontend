# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "agreements#index"

  resources :agreements, only: [:show]
  resources :agreements, only: %i[show index], constraints: { format: :json }
  resources :powers, only: %i[index show]
  resources :processors, only: %i[index show]
  resources :control_people, only: %i[index show], path: :controllers
  resources :search, only: [:index]
  resources :update_logs, only: [:index]
  resources :metadata, only: [:show], constraints: { format: :json }
end
