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
  resources :topics
  resources :pictures
  resources :covers
  resources :videos
  resources :tutorials


end
