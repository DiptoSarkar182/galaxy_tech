Rails.application.routes.draw do
  devise_for :users, :controllers => {registrations: 'registrations'}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "products#index"

  resources :products do
    resources :cart_items do
      member do
        post :increase_quantity
        post :decrease_quantity
      end
    end
  end

  resources :carts do
    member do
      post :increase_quantity
      post :decrease_quantity
    end
  end

  resources :orders do
    collection do
      get :checkout
    end
  end

  resources :admin_dashboards, only: [:index, :create, :destroy]

end
