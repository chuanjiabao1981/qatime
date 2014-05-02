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

  get "topics/node:id"      => "topics#node",       as: 'node_topics'
  get "tutorials/node:id"   => "tutorials#node",    as: 'node_tutorials'
  get "courses/node:id"     => "courses#node",      as: 'node_courses'
  resources :schools
  resources :cities
  resources :groups
  resources :topics
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


  devise_for :users
  devise_for :teachers, controllers: { registrations: "teachers/registrations" }

end
