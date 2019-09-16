Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: %i[index edit update destroy]
  end
  resources :orders
  resources :order_products
  devise_for :users, controllers:{
    registrations: 'registrations'
  }
  resources :products
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
