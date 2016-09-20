Payment::Engine.routes.draw do

  resources :users, only: [] do
    resources :orders, only: [:index, :show, :destroy] do
      member do
        get :result
        get :pay
        patch :cancel_order
      end
    end

    resources :recharges, only: [:new, :show, :edit, :create], shallow: true do
      member do
        get :pay
      end
    end

    get :cash, on: :member

    resources :change_records, only: [:index]
  end

  resources :orders, only: [] do
    member do
      get :pay
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
