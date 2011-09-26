Extrapoints::Application.routes.draw do

  resources :operations, :donations

  get "sessions/new"

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"

  root :to => "sessions#new"
  resources :users do
    resources :notifications
    member do
      get "history"
    end
  end
  resources :sessions
  resources :teachers do
    collection do
      get "menu"
    end
  end
  resources :students do
    collection do
      get "ranking"
      get "menu"
    end
    member do
      get "make_donation"
      get "make_withdraw"
      post "donate"
      post "withdraw"
    end
  end
end
