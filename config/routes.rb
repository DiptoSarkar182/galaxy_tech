Rails.application.routes.draw do
  devise_for :users, :controllers => {registrations: 'registrations',
                                      omniauth_callbacks: 'callbacks',
                                      passwords: 'passwords',}
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "products#index"

  resources :products do
    collection do
      get :search_product
      get :search_product_by_component
    end
    member do
      post :add_to_cart
      post :increase_quantity
      post :decrease_quantity
    end
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
    resources :product_ratings_and_reviews
    collection do
      get :checkout
      post :submit_stripe_payment
    end

    member do
      get :stripe_payment
    end
  end


  resources :admin_dashboards do
    collection do
      get :pending_orders
      get :all_products
    end
    member do
      patch :change_customer_order_status
    end
  end

  resources :add_to_wish_lists

end
