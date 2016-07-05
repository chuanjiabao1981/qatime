LiveStudio::Engine.routes.draw do
  get 'courses/index'

  get 'courses/teate'

  get 'courses_controller/index'

  resources :courses, only: [:index] do
    resources :orders, only: [:new, :create, :pay, :show] # 下单
    member do
      post 'taste' # 试听
    end

    resources :lessons, only: [:show] do
      member do
        get :play
      end
    end
  end

  scope module: 'manager' do
    resources :managers, only: [] do
      resources :courses
    end
  end

  namespace :manager do
    resources :courses do
      member do
        post :publish
      end
    end
  end

  namespace :teacher do
    resources :courses, only: [:index, :show, :edit, :update] do
      resources :lessons do
        member do
          patch :begin_live_studio
          patch :end_live_studio
          patch :ready
          patch :complete
        end
      end
      member do
        patch :close
        patch :channel
      end
    end
  end

  namespace :student do
    resources :courses, only: [:index, :show]
  end
end
