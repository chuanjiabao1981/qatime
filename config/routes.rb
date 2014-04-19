Qatime::Application.routes.draw do
  root :to => "home#index"
  devise_for :users

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
  resources :courses,shallow:true do
    resources :lessons
  end


end
