Rails.application.routes.draw do
  root to: 'home#index'

  resources :products, only: %i[show]
  resources :orders, only: %i[index new create]
  resources :order_products, only: %i[index create destroy]
  devise_for :users, controllers: {
    registrations: 'registrations'
  }
  namespace :admin do
    resources :users, only: %i[index edit update destroy]
    resources :products, except: %i[show]
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
