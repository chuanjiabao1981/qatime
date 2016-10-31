Recommend::Engine.routes.draw do
  namespace :admin do
    resources :positions do
      resources :teacher_items, only: [:new, :create, :edit, :update, :destroy], shallow: true
      resources :live_studio_course_items, only: [:new, :create, :edit, :update, :destroy], shallow: true
    end
  end
end
