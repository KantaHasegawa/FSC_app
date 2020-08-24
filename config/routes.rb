Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %i[index show]
  resources :bands
  get '/users/sign_out' => 'devise/sessions#destroy'
  root to: 'static_pages#home'
  get 'static_pages/help'


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
end
