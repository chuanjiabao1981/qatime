LiveStudio::Engine.routes.draw do
  get 'courses/index'

  get 'courses/teate'

  get 'courses_controller/index'

  resources :courses, only: [:index, :show] do
    resources :orders, only: [:new, :create, :pay, :show] # 下单
    member do
      post 'taste' # 试听
      get :play # 观看直播
      post :update_notice
      patch :publish
      get :refresh_current_lesson
    end

    resources :lessons, only: [:show] do
      member do
        get :play
        patch :completed
      end
    end
  end

  scope module: 'manager' do
    resources :managers, only: [] do
      resources :courses
    end
  end

  scope module: 'seller' do
    resources :sellers, only: [] do
      resources :courses do
        patch :publish, on: :member
      end
    end
  end

  scope module: 'waiter' do
    resources :waiters, only: [] do
      resources :courses, only: [:index, :show, :edit, :update] do
        patch :publish, on: :member
      end
    end
  end

  scope module: :teacher do
    resources :teachers, only: [] do
      resources :courses, only: [:index, :show, :edit, :update, :create] do
        member do
          patch :close
          patch :channel
          get :update_class_date
        end
      end
      resources :lessons do
        member do
          patch :begin_live_studio
          patch :end_live_studio
          patch :ready
          patch :complete
        end
      end
    end
  end


  # namespace :teacher do
  #   resources :courses, only: [:index, :show, :edit, :update] do
  #     resources :lessons do
  #       member do
  #         patch :begin_live_studio
  #         patch :end_live_studio
  #         patch :ready
  #         patch :complete
  #       end
  #     end
  #     member do
  #       patch :close
  #       patch :channel
  #     end
  #   end
  # end

  # namespace :student do
  #   resources :courses, only: [:index, :show]
  # end
  scope module: :student do
    resources :students do
      resources :courses, only: [:index, :show]
    end
  end

  get 'helps/courses', to: 'helps#course'
end
