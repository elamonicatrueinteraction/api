Rails.application.routes.draw do
  scope protocol: SECURE_PROTOCOL do

  # ╭─ Public Accesible URL's / Path's
    root to: 'home#show'
    post 'authenticate', action: :authenticate, controller: :authentication

    namespace :webhooks do
      post 'mercadopago/payment/:uuid', action: :payment_notification, controller: :mercadopago, as: :mercadopago_payment

      # post 'shippify/create_delivery', action: :create_delivery, controller: :shippify
      post 'shippify/update_delivery', action: :update_delivery, controller: :shippify
      # post 'shippify/create_trip', action: :create_trip, controller: :shippify
    end
  # ╰─ End of Public Accesible URL's / Path's

  # ╭─ Private Accesible URL's / Path's
    resources :shippers, only: [ :create, :show, :index, :update ] do
      resources :vehicles, only: [ :create, :index, :update ]
      resources :bank_accounts, only: [ :index, :show, :create, :update ]
    end

    resources :bank_accounts, only: [ :show, :create, :update ]

    resources :vehicles, only: [ :create, :update ] do
      resources :verifications, only: [ :create, :index, :update, :destroy ]
    end

    resources :institutions, only: [ :create, :show, :index, :update, :destroy ] do
      resources :addresses, only: [ :create, :index, :update, :destroy ]
    end

    resources :orders, only: [ :create, :show, :index, :destroy ] do
      resources :deliveries, only: [ :index, :show, :destroy ]
      resources :payments, only: [ :index, :show, :create ]
    end

    resources :deliveries, only: [ :create, :update, :destroy ] do
      resources :packages, only: [ :create, :index, :show, :update, :destroy ]
      resources :payments, only: [ :index, :show, :create ]
    end

    resources :trips, only: [ :create, :show, :index, :update, :destroy  ] do
      member do
        post :broadcast
      end
    end
  # ╰─ End of Private Accesible URL's / Path's

  # ╭─ ShipperApi Endpoints URL's / Path's
    scope module: 'shipper_api', path: 'shipper' do
    # ╭─ Public Accesible URL's / Path's
      post 'authenticate', action: :authenticate, controller: :authentication
    # ╰─ End of Public Accesible URL's / Path's

    # ╭─ Private Accesible URL's / Path's
      get 'hello', action: :hello, controller: :base

      resources :trips, only: [ :index, :show ]
    # ╰─ End of Private Accesible URL's / Path's
    end
  # ╰─ End of ShipperApi Endpoints URL's / Path's
  end
end
