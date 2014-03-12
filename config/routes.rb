Qatime::Application.routes.draw do
  root :to => "home#index"
  devise_for :users

  namespace :cpanel do
    resources :nodes
    resources :sections
    resources :tutorials
  end


  get "topics/node:id" => "topics#node", as: 'node_topics'
  resources :topics
  resources :pictures
  resources :covers
  resources :videos


end
