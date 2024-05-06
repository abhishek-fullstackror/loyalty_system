# config/routes.rb
Rails.application.routes.draw do
  root 'home#index'
  draw(:admin)
  devise_for :users
  resources :transactions, only: %i(new create)
  resources :rewards, only: %i(index)
end
