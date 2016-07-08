Payment::Engine.routes.draw do

  resources :users, only: [] do
    resources :orders, only: [:index, :show, :destroy] do
      collection do
        get :result
      end
    end

    resources :change_records, only: [:index]
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
