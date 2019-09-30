Rails.application.routes.draw do

  get 'audit/index'

  get '_healthcheck', action: :health, controller: :health
  get 'ping_async', action: :ping_async, controller: :health

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :v2 do
    resources :institutions, only: [] do
      resources :payments, only: [:index, :update]
    end
  end

  root to: 'home#show'

  namespace :job do
    get 'sync_coupons', action: :sync_coupons
    get 'sync_missing_coupons', action: :sync_missing_coupons
    get 'cancel_remote_payment/:payment_id', action: :cancel_remote_payment
    get 'backup'
  end

  namespace :account_balances do
    get '', action: :index
  end

  namespace :untracked_activity do
    post '', action: :create
  end

  namespace :reports do
    get 'remote_payment_report', action: :remote_payment_report
  end

  namespace :webhooks do
    post 'mercadopago/payment/:uuid', action: :payment_notification, controller: :mercadopago, as: :mercadopago_payment
  end

  namespace :payments do
    put 'obsolesce/:id', action: :obsolesce
  end

  scope module: :v1, constraints: ApiConstraint.new(version: 1, default: true) do
    resources :districts, only: [:index]
    resources :shippers, only: [ :create, :show, :index, :update ] do
      resources :vehicles, only: [ :create, :index, :update ]
      resources :bank_accounts, only: [ :index, :show, :create, :update ]
    end

    resources :bank_accounts, only: [ :show, :create, :update ]

    resources :vehicles, only: [ :create, :update ] do
      resources :verifications, only: [ :create, :index, :update, :destroy ]
    end

    resources :institutions, only: [] do
      resources :addresses, only: [ :create, :index, :update, :destroy ]
      resources :orders, only: [ :index ]
      resources :trips, only: [ :index ] do
        collection do
          get :export
        end
      end
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
      collection do
        get :export
      end
      member do
        post :broadcast
        post :pause
      end
    end
  end
# | - End of Version 1
# ╰─ End of Private Accesible URL's / Path's

# ╭─ ShipperApi Endpoints URL's / Path's
  scope module: 'shipper_api', path: 'shipper' do
  # ╭─ Public Accesible URL's / Path's
    post 'authenticate', action: :authenticate, controller: :authentication
  # ╰─ End of Public Accesible URL's / Path's

  # ╭─ Private Accesible URL's / Path's
    get 'hello', action: :hello, controller: :base

    resources :trips, only: [ :index, :show ] do
      resources :milestones, only: [ :create ]

      collection do
        get :pending
        get :accepted
      end

      member do
        post :accept
        # post :reject
      end
    end
  end

  namespace :services do
    resources :orders, only: [:index, :create]
    namespace :orders do
      get 'last_order_date', action: :last_order_date
    end

    resources :account_balances, only: [:index, :show]
  end



  match '*path', to: ->(_) { [ 404, { }, [':/'] ] }, via: :all
end
