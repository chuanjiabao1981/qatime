Exam::Engine.routes.draw do
  namespace :station do
    resources :workstations, only: [] do
      resources :papers

      resources :package_topics, only: [:edit, :update]
      resources :group_topics, only: [:edit, :update]
      resources :topics, only: [:edit, :update]
    end
  end
end
