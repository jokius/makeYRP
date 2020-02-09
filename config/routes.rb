# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  devise_for :admin_users, ActiveAdmin::Devise.config.merge(class_name: 'User')
  ActiveAdmin.routes(self)

  root 'games#index'

  resources :games, except: %i[update delete] do
    scope module: :games do
      resources :sheets
      resources :pages
      resources :messages
      resources :menus_items
    end
  end

  resources :users, only: :none do
    get :current, on: :collection
  end

  resources :systems, except: %i[delete update]

  resource :folder, only: %i[create show]
  resources :folders, only: %i[update destroy] do
    scope module: :folders do
      resources :images
    end
  end
end
