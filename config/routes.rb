Rails.application.routes.draw do

  root "calendars#index"

  devise_for :admin_users, :controllers => { :omniauth_callbacks => "admin_users/omniauth_callbacks" }
  resources :calendars
  resources :auth
  
  get 'callback', to: "auth#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
