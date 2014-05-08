Qatime::Application.routes.draw do
  root :to => "home#index"

  namespace :cpanel do
    resources :nodes
    resources :sections
    resources :tutorials
  end

  resources :tutorials do
    resources :comments
  end

  get "topics/node:id"      => "topics#node",           as: 'node_topics'
  get "tutorials/node:id"   => "tutorials#node",        as: 'node_tutorials'
  get "courses/node:id"     => "courses#node",          as: 'node_courses'
  get "teachers/home"       => "teachers/home#main",    as: 'teachers_home'
  get "admins/home"         => "admins/home#main",      as: 'admins_home'
  resources :groups
  resources :topics do
    resources :replies
  end

  resources :pictures
  resources :covers
  resources :videos
  resources :tutorials

  resources :groups do
    resources :courses
  end
  resources :lessons
  resources :courses do
    resource :topics
    resource :lessons
  end
  namespace :admins do
    resources :teachers
    resources :groups
    resources :schools
    resources :cities
  end
  namespace :teachers do
    resources :registrations
  end

  resources :sessions
  get    '/signin',  to: 'sessions#new'
  delete '/signout', to: 'sessions#destroy'

  #devise_for :users,    :controllers => { :sessions => 'users/sessions' }
  #devise_for :teachers, :controllers => { :registrations =>  'teachers/registrations'},:skip=>:sessions
  #devise_for :admins,   :skip=>:sessions

end
