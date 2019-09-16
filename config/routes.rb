Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: %i[index edit update destroy]
  end
  resources :orders, only: %i[index new create]
  resources :order_products, only: %i[index create destroy]
  devise_for :users, controllers:{
    registrations: 'registrations'
  }
  resources :products
  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
