# config/routes.rb
Rails.application.routes.draw do
  resources :users
  resources :transactions, only: [:create]
  resources :rewards, only: [:index]
end
