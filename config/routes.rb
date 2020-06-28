# frozen_string_literal: true

Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    devise_for :users, controllers: { registrations: 'registrations', sessions: 'sessions' }

    resources :games, except: %i[update delete] do
      member do
        post :join
        put :switch_status
      end

      scope module: :games do
        resources :users, only: :index
        resources :sheets, only: :index
        resources :messages, only: :index
        resources :items, only: :index
      end
    end

    resources :pages, only: :none do
      scope module: :pages do
        resources :tokens, only: :index
        resources :images, only: :index
        resources :graphics, only: :index
      end
    end

    resources :users, only: :none do
      get :current, on: :collection
    end

    resources :systems, except: %i[delete update]

    resource :folder, only: %i[create show]
    resources :folders, only: %i[show update destroy] do
      get :tree, on: :collection

      scope module: :folders do
        resources :images
      end
    end

    resource :acl, only: :show

    namespace :admin do
      resources :games, only: %i[index destroy]
    end
  end
end
