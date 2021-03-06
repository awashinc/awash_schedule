Rails.application.routes.draw do

  root "dashboards#index"

  devise_for :admin_users, :controllers => { :omniauth_callbacks => "admin_users/omniauth_callbacks" }
  resources :calendars do
    get :specific_list, on: :member
    get :specific_edit, on: :member
    put :specific_update, on: :member
  end
  resources :auth
  resources :dashboards do
    get :fetch_forecast, on: :collection
  end

  get 'callback', to: "auth#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
end
