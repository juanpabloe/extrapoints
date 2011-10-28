Extrapoints::Application.routes.draw do

  resources :operations, :donations, :notifications

  get "sessions/new"

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"

  root :to => "sessions#new"

  resources :users do
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
      get "give_present"
      post "donate"
      post "withdraw"
    end
  end
end
