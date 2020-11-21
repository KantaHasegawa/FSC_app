# frozen_string_literal: true

Rails.application.routes.draw do
  get 'notifications/index'
  # get "/bands/:id/invitation" => 'bands#invitation'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  resources :users, only: %i[index show]
  resources :bands do
    member do
      get 'invitation'
      patch 'invitation_update'
      get 'destroy_member'
      delete 'destroy_member_delete'
    end
  end
  resources :notifications, only: %i[index]
  get '/users/sign_out' => 'devise/sessions#destroy'
  root to: 'static_pages#home'
  get 'static_pages/help'
  post 'relationships/participation/:id' => 'relationships#participation'
  post 'relationships/:id'               => 'relationships#update'
  delete 'relationships/:id' => 'relationships#destroy'
end
