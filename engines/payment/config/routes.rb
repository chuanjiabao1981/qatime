Payment::Engine.routes.draw do
  namespace :station do
    resources :workstations, only: [:show] do
      member do
        get :cash, action: :earning_records
        get :earning_records
        get :withdraws
      end
      resources :sale_tasks do
        member do
          patch :start
          patch :close
        end
      end
    end
  end

  resources :withdraw_remits

  resources :users, only: [] do
    resources :orders, only: [:index, :show, :destroy] do
      member do
        get :result
        get :pay
        patch :cancel_order
        get :refund
        post :refund_create
        put :cancel_refund
      end
    end

    resources :recharges, only: [:new, :show, :edit, :create], shallow: true do
      member do
        put :pay
      end
    end

    member do
      get :cash
      get :recharges
      get :withdraws
      get :consumption_records
      get :earning_records
      get :refunds
    end

    resources :change_records, only: [:index]
    resources :withdraws, only: [:new, :create] do
      collection do
        get :complete
      end
      put :cancel, on: :member
    end
  end

  resources :orders, only: [] do
    member do
      get :pay
    end
  end

  resources :transactions, only: [:show] do
    member do
      get :result
      match :notify, via: [:get, :post]
      post :pay
    end
  end

  resources :live_studio_lessons, only: [] do
    resources :billings, only: [:index]
  end

  resources :live_studio_courses, only: [] do
    resources :billings, only: [:index]
  end

  resources :live_studio_lessons, only: [] do
    resources :billings, only: [:index]
  end

  post :notify, to: "orders#notify"
end
