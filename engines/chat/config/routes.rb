Chat::Engine.routes.draw do
  resources :live_studio_courses, only: [] do
    resources :teams, only: [:create, :update]
  end
  resources :users, only: [] do
    resources :account, only: [:create, :update]
  end
end
