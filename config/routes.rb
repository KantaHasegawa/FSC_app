Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => 'users/registrations' }
  resources :users, only: %i[index show]
  resources :bands
  get '/users/sign_out' => 'devise/sessions#destroy'
  root to: 'static_pages#home'
  get 'static_pages/help'
  post 'relationships/participation/:id' => 'relationships#participation'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
end
