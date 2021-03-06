LiveStudio::Engine.routes.draw do
  root to: "courses#index"
  get 'courses/index'
  get 'courses/teate'

  get ':course_id/realtime/announcements', to: 'realtime#announcements'
  get ':course_id/realtime/members', to: 'realtime#members'

  resources :attachments, only: [:create]

  namespace :admin do
    resources :courses, only: [:index]
    resources :course_requests, only: [:index] do
      member do
        patch :accept
        patch :reject
      end
    end
  end

  resources :orders, only: [] do
    collection do
      post :check_coupon
    end
  end

  resources :courses, only: [:index, :new, :create, :edit, :update, :show] do
    resources :orders, only: [:new, :create, :pay, :show] # 下单
    resources :announcements, only: [:index, :update, :create], shallow: true

    collection do
      get :schedule_sources
      post :preview
      patch :preview
    end

    member do
      post 'taste' # 试听
      get :play # 观看直播
      post :update_notice
      patch :publish
      get :refresh_current_lesson
      get :live_status
      get :live_info
      get :update_class_date
      get :for_free
      patch :update_lessons
      post :inc_users_count
    end

    resources :lessons, only: [:show], shallow: true do
      member do
        get :play
        patch :completed
        get :videos
        get :replay
      end
    end
  end

  # 一对一互动
  resources :interactive_courses, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
    collection do
      post :preview
      patch :preview
    end
    member do
      get :update_class_date
      patch :update_lessons
      get :play # 观看直播
      get :live_info
      get :interactive # 互动
    end

    resources :orders, only: [:new, :create]
    resources :announcements, only: [:index, :update, :create], shallow: true

    resources :interactive_lessons, only: [], shallow: true do
      member do
        get :replay
      end
    end
  end

  # 视频课
  resources :video_courses, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
    collection do
      post :preview
      patch :preview
    end

    member do
      get :taste # 试听
      get :deliver
      get :play # 观看直播
      post :update_notice
      get :preview
      post :inc_users_count
    end

    resources :orders, only: [:new, :create]
    resources :announcements, only: [:index, :update, :create], shallow: true

    resources :video_lessons, only: [], shallow: true do
      member do
        get :play
      end
    end
  end

  # 小班课
  resources :customized_groups, only: [:index, :show] do
    collection do
      post :preview
      patch :preview
    end

    member do
      get :for_free
      get :play
      get :live_info
      post :inc_users_count
    end
    resources :orders, only: [:new, :create] # 下单
    resources :announcements, only: [:index, :update, :create], shallow: true

    resources :scheduled_lessons, only: [], shallow: true do
      member do
        get :replay
      end
    end

    resources :homeworks, only: [:index, :new, :create]
    resources :questions, only: [:index, :new, :create]
  end

  resources :questions, only: [] do
    resources :answers, only: [:new, :create, :edit, :update]
  end

  resources :student_homeworks, only: [:edit, :update] do
    resources :corrections, only: [:new, :edit, :create, :update]
  end

  namespace :station do
    resources :workstations, only: [] do
      resources :courses, only: [:index] do
        collection do
          get :my_courses
        end
        member do
          get :send_qr_code
        end
      end
      resources :course_records, only: [:index] do
        collection do
          get :my_publish
        end
      end
      resources :course_requests, only: [:index] do
        member do
          patch :accept
          patch :reject
        end
      end
      resources :course_invitations, only: [:index, :new, :create] do
        member do
          patch :cancel
        end
      end
      resources :interactive_courses, only: [:index] do
        member do
          get :play
        end
      end
      resources :video_courses, only: [:index, :edit, :update] do
        collection do
          get :my_publish
          get :my_sells
          get :list
          get :audits
        end
        member do
          get :send_qr_code
          patch :publish
          post :audit
        end
      end
      resources :customized_groups, only: [:index, :new, :create] do
        collection do
          get :sells_list
        end
        member do
          get :update_class_date
          patch :update_lessons
          get :send_qr_code
        end
      end
    end
  end

  # scope module: 'workstation' do
  #   resources :users, only: [] do
  #     resources :courses, only: [:index]
  #     resources :course_requests, only: [:index] do
  #       member do
  #         patch :accept
  #         patch :reject
  #       end
  #     end
  #     resources :course_invitations, only: [:index, :new, :create] do
  #       member do
  #         patch :cancel
  #       end
  #     end
  #   end
  # end

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
        get :schedule_data
        get :settings
      end
      resources :courses, only: [:index, :show, :edit, :update, :create, :destroy] do
        member do
          patch :close
          patch :channel
          get :update_class_date
          patch :update_lessons
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

      resources :course_invitations, only: [:index, :destroy]
      resources :interactive_courses, only: [:index]
      resources :video_courses
      resources :customized_groups, only: [:index]
      resources :homeworks, only: [:index]
      resources :student_homeworks, only: [:index]
      resources :questions, only: [:index]
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
        get :schedule_data
        get :settings
        get :tastes
        get :taste_records
      end
      resources :courses, only: [:index, :show]
      resources :interactive_courses, only: [:index, :show]
      resources :video_courses, only: [:index]
      resources :customized_groups, only: [:index]
      resources :student_homeworks, only: [:index]
      resources :questions, only: [:index]
    end
  end

  get 'helps/courses', to: 'helps#course'
end
