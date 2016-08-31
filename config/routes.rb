Qatime::Application.routes.draw do
  root :to => "home#index"

  get 'welcome/download'
  get "topics/node:id"      => "topics#node",           as: 'node_topics'
  get "courses/node:id"     => "courses#node",          as: 'node_courses'
  get "teachers/home"       => "teachers/home#main",    as: 'teachers_home'
  get "admins/home"         => "admins/home#main",      as: 'admins_home'
  get "students/home"       => "students/home#main",    as: 'students_home'
  get "managers/home"       => "managers/home#main",    as: 'managers_home'
  get "sellers/home"        => "sellers/home#main",     as: 'sellers_home'
  get "waiters/home"        => "waiters/home#main",     as: 'waiters_home'

  resources :curriculums
  resources :qa_faqs do
    collection do
      get 'courses'
      get 'teacher'
      get 'student'
    end
  end


  resources :pictures

  resources :replies
  resources :topics do
    resources :replies
  end

  resources :courses
  resources :lessons do
    resources :topics
  end
  resources :lessons


  namespace :admins do
    resources :cities
    resources :recharge_codes
    resources :faq_topics
    resources :faqs
    resources :teaching_programs
    resources :managers
    resources :register_codes
    resources :faq_topics do
      resources :faqs
    end
    resources :workstations
    resources :softwares do
      member do
        get :run
      end
    end
  end

  namespace :managers do
    resources :register_codes
    resources :lessons do
      collection do
        get 'state'
      end
    end
    resources :sellers, except: [:index, :show]
    resources :waiters, except: [:index, :show]
  end

  namespace :teachers do
    resources :groups do
      resources :courses
    end
    resources :curriculums do
      member do
        get 'edit_courses_position'
      end
      resources :courses
    end
    resources :lessons do
      resources :qa_files
    end
    resources :courses do
      resources :lessons
    end
    resources :videos
    resources :faqs
    resources :faq_topics
  end

  namespace :students do
    resources :recharge_records
    resources :faqs
    resources :faq_topics
    resources :orders, only: [:index] do
      member do
        get :pay
      end
    end
  end

  post 'students/courses/:id' => "students/courses#purchase", as: 'students_course_purchase'

  resources :schools do
    resources :register_codes do
      collection do
        get 'downloads' , defaults: { format: 'xls' }
        get 'batch_make'
      end
    end
  end

  resources :sessions
  resources :passwords, only: [:new, :create]
  resources :teachers do
    collection do
      get 'search'
    end
    member do
      get 'pass'
      get 'unpass'
      get 'lessons_state'
      get 'students'
      get 'curriculums'
      get 'info'
      get 'questions'
      get 'topics'
      get 'customized_tutorial_topics'
      get 'customized_courses'
      get 'homeworks'
      get 'solutions'
      get 'keep_account'
      get 'notifications'
      get :admin_edit
      patch :admin_update
    end
  end
  resources :students do
    collection do
      get 'search'
    end
    member do
      get 'info'
      get 'teachers'
      get 'questions'
      get 'topics'
      get 'customized_tutorial_topics'
      get 'customized_courses'
      get 'homeworks'
      get 'solutions'
      get 'notifications'
      get :admin_edit
      patch :admin_update
    end
    resources :customized_courses do
      member do
        get 'teachers' #这个是给 customized_courses 创建后用的
      end
      collection do
        get 'teachers' #这个是给 customized_courses 未创建的时候用的
        get 'get_sale_price'
      end
    end
  end
  resources :managers do
    member do
      get 'customized_courses'
      get 'payment'
      get 'action_records'
      get :waiters
      get :sellers
    end
  end

  resources :customized_courses,only:[:show,:edit,:update] do
    resources :customized_tutorials
    member do
      get 'topics'
      get 'homeworks'
      get 'solutions'
      get 'course_issues'
      get 'action_records'
    end
    resources :course_issues
    resources :homeworks,only:[:show,:edit,:update,:new,:create]
    resources :customized_course_message_boards
  end
  resources :homeworks do
    member do
      Examination.state_machines[:state].events.map(&:name).each do |x|
        post x
      end
    end

    resources :homework_solutions, controller: :solutions
  end
  resources :homework_solutions, controller: :solutions do
    resources :homework_corrections, controller: :corrections
    member do
     Solution.state_machines[:state].events.map(&:name).each do |x|
       post x
     end
    end
  end

  resources :homework_corrections, controller: :corrections

  resources :solutions do
    resources :corrections
  end

  resources :corrections
  resources :customized_tutorials do

    resources :tutorial_issues
    resources :exercises
  end

  resources :course_issues do
    member do
      Topic.state_machines[:state].events.map(&:name).each do |x|
        post x
      end
    end

    resources :course_issue_replies
  end

  resources :course_issue_replies

  resources :tutorial_issues do
    member do
      Topic.state_machines[:state].events.map(&:name).each do |x|
        post x
      end
    end

    resources :tutorial_issue_replies
  end

  resources :tutorial_issue_replies


  resources :exercises do
    member do
      Examination.state_machines[:state].events.map(&:name).each do |x|
        post x
      end
    end
    resources :exercise_solutions, controller: :solutions
  end
  resources :exercise_solutions, controller: :solutions do
    resources :exercise_corrections,controller: :corrections
    member do
     Solution.state_machines[:state].events.map(&:name).each do |x|
       post x
     end
    end
  end

  resources :exercise_corrections,controller: :corrections



  resources :questions do

    resources :answers
    collection do
      get 'teachers'
      get 'student'
      get 'teacher'
    end
  end

  resources :accounts do
    resources :deposits
    resources :withdraws
  end

  resources :comments

  resources :videos do
    member do
      get 'convert'
    end
  end
  resources :teaching_videos
  resources :vip_classes
  resources :learning_plans do
    collection do
      get 'teachers'
    end
  end

  resources :qa_files
  resources :action_records
  resources :notifications


  resources :customized_course_message_boards do
    resources :customized_course_messages
  end
  resources :customized_course_messages do
    resources :customized_course_message_replies
  end

  resources :customized_course_message_replies

  get    '/signin',  to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'

  require 'sidekiq/web'
  require 'admin_constraint.rb'
  mount Sidekiq::Web => '/sidekiq', :constraints => AdminConstraint.new

  mount CourseLibrary::Engine, at: '/course_library'

  mount Qawechat::Engine, at: '/qawechat'
  get 'auth/wechat/callback' => 'qawechat/omniauth_callbacks#wechat'

  # 直播
  mount LiveStudio::Engine, at: '/live_studio'
  # 支付
  mount Payment::Engine, at: '/payment'
  # 聊天
  mount Chat::Engine, at: '/chat'
  # API
  mount Qatime::API => '/'


  resources :qa_file_quoters

  namespace :ajax do
    resource :captchas, only: [:create] do
      post :verify, on: :member
    end
  end
end
