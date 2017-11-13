Rails.application.routes.draw do
  scope protocol: SECURE_PROTOCOL do
    root to: 'home#show'

  # ╭─ Public Accesible URL's / Path's
    post 'authenticate', action: :authenticate, controller: :authentication

    resources :shippers, only: [ :create, :index, :update ] do
      resources :vehicles, only: [ :create, :index, :update ]
    end

    resources :vehicles, only: [ :create, :update ] do
      resources :verifications, only: [ :create, :index, :update, :destroy ]
    end
  # ╰─ End of Public Accesible URL's / Path's
  end
end
