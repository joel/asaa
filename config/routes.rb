# frozen_string_literal: true

# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

require "sidekiq/web"

Rails.application.routes.draw do
  resources :notes
  mount Sidekiq::Web => "/sidekiq"

  root to: "welcome#index"

  get "welcome/index"

  concern :attachable do
    resources :attachments
  end
  resources :attachments
  resources :users, concerns: :attachable
  resources :posts
end
