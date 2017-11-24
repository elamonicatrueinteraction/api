Rails.application.routes.draw do
  scope protocol: SECURE_PROTOCOL do

  # ╭─ Public Accesible URL's / Path's
    root to: 'home#show'
    post 'authenticate', action: :authenticate, controller: :authentication
  # ╰─ End of Public Accesible URL's / Path's

  # ╭─ Private Accesible URL's / Path's
    resources :shippers, only: [ :create, :show, :index, :update ] do
      resources :vehicles, only: [ :create, :index, :update ]
      resources :bank_accounts, only: [ :index, :show, :create, :update ]
    end

    resources :bank_accounts, only: [ :index, :show, :create, :update ]

    resources :vehicles, only: [ :create, :update ] do
      resources :verifications, only: [ :create, :index, :update, :destroy ]
    end

    resources :institutions, only: [ :create, :show, :index, :update, :destroy ] do
      resources :addresses, only: [ :create, :index, :update, :destroy ]
    end

    resources :orders, only: [ :create, :show, :index, :update, :destroy ] do
      resources :deliveries, only: [ :index ]
    end

  # ╰─ End of Private Accesible URL's / Path's
  end
end
