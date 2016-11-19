LiveStudio::Engine.routes.draw do
  root to: "courses#index"
  get 'courses/index'
  get 'courses/teate'

  namespace :admin do
    resources :courses, only: [:index]
    resources :course_requests, only: [:index]
  end

  resources :courses, only: [:index, :new, :create, :edit, :update, :show] do
    resources :orders, only: [:new, :create, :pay, :show] # 下单

    collection do
      get :schedule_sources
      get :preview
    end

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
      resources :course_invitations, only: [:index, :new, :create] do
        member do
          patch :cancel
        end
      end
      resources :course_requests, only: [:index] do
        member do
          patch :accept
          patch :reject
        end
      end
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
      member do
        get :schedules
        get :settings
      end
      resources :courses, only: [:index, :show, :edit, :update, :create, :destroy] do
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

      resources :course_invitations
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
    resources :students, only: [] do
      member do
        get :schedules
        get :settings
      end
      resources :courses, only: [:index, :show]
    end
  end

  get 'helps/courses', to: 'helps#course'
end
