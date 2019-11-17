# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  root 'games#index'

  resources :games, except: %i[update delete] do
    scope module: :games do
      resources :sheets
      resources :pages
    end
  end

  resources :users, only: :none do
    get :current, on: :collection
  end

  resources :systems, except: %i[delete update]
  resource :folder
  resources :folders, only: :none do
    scope module: :folders do
      resources :images
    end
  end
end
