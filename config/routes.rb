Rails.application.routes.draw do
  scope protocol: SECURE_PROTOCOL do
    root to: 'home#show'

  # ╭─ Public Accesible URL's / Path's
    post 'authenticate', action: :authenticate, controller: :authentication

    resources :shippers, only: [ :create, :show, :index, :update ] do
      resources :vehicles, only: [ :create, :index, :update ]
      resources :bank_accounts, only: [:index, :show, :create, :update]
    end

  resources :bank_accounts, only: [:index, :show, :create, :update]

  resources :vehicles, only: [ :create, :update ] do
      resources :verifications, only: [ :create, :index, :update, :destroy ]
    end
  # ╰─ End of Public Accesible URL's / Path's
  end
end
