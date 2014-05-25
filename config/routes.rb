Qatime::Application.routes.draw do
  root :to => "home#index"

  resources :tutorials do
    resources :comments
  end

  get "topics/node:id"      => "topics#node",           as: 'node_topics'
  get "tutorials/node:id"   => "tutorials#node",        as: 'node_tutorials'
  get "courses/node:id"     => "courses#node",          as: 'node_courses'
  get "teachers/home"       => "teachers/home#main",    as: 'teachers_home'
  get "admins/home"         => "admins/home#main",      as: 'admins_home'
  get "students/home"       => "students/home#main",    as: 'students_home'

  resources :groups
  resources :topics do
    resource :replies
  end
  resources :pictures
  resources :covers
  resources :tutorials
  resources :topics do
    resources :replies
  end

  resources :lessons
  resources :courses do
    resource :topics
  end

  namespace :admins do
    resources :teachers
    resources :groups
    resources :schools
    resources :cities
    resources :recharge_codes
  end
  namespace :teachers do
    resources :registrations
    resources :groups do
      resources :courses
    end
    resources :courses do
      resources :lessons
    end
    resources :videos
  end

  namespace :students do
    resources :registrations
    resources :recharge_records
  end


  resources :sessions
  get    '/signin',  to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'

end
