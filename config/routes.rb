Rails.application.routes.draw do
  devise_for :users
  get '/users/sign_out' => 'devise/sessions#destroy'
  resources :users, only: %i[index show]
  root to: 'static_pages#home'
  get 'static_pages/home'
  get 'static_pages/help'
  resources :bands
  resources :relationships,only: %i[create new edit update destroy]

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
end
