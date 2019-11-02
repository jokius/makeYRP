# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  root 'games#index'

  resources :games, except: %i[update delete]
  resources :users, only: :none do
    get :current, on: :collection
  end

  resources :systems, except: %i[delete update]
end
