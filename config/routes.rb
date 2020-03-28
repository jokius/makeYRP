# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }
  root 'games#index'

  resources :games, except: %i[update delete] do
    post :join, on: :member

    scope module: :games do
      resources :sheets, only: :index
      resources :messages, only: :index
    end
  end

  resources :pages, only: :none do
    scope module: :pages do
      resources :tokens, only: :index
      resources :graphics, only: :index
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

  resource :acl, only: :show

  namespace :admin do
    resources :games, only: %i[index destroy]
  end
end
