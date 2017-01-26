Recommend::Engine.routes.draw do
  namespace :admin do
    resources :positions do
      resources :teacher_items, only: [:new, :create, :edit, :update, :destroy], shallow: true
      resources :live_studio_course_items, only: [:new, :create, :edit, :update, :destroy], shallow: true
      resources :banner_items, only: [:new, :create, :edit, :update, :destroy], shallow: true

      member do
        put :change_status
      end
    end
  end

  namespace :manager do
    resources :positions, only: [:index, :show] do
      resources :items, shallow: true
    end
  end

  resources :positions do
    resources :teacher_items, only: [:new, :create, :edit, :update, :destroy], shallow: true
    resources :live_studio_course_items, only: [:new, :create, :edit, :update, :destroy], shallow: true
    resources :banner_items, only: [:new, :create, :edit, :update, :destroy], shallow: true
    resources :items, only: [:new, :create], shallow: true
  end
end
