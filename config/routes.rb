Extrapoints::Application.routes.draw do

  resources :notifications

  get "sessions/new"

  get "log_out" => "sessions#destroy", :as => "log_out"
  get "log_in" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"

  root :to => "sessions#new"

  resources :users do
    resources :operations do
      collection do
        get "give_present"        
      end
    end
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
  end
end
