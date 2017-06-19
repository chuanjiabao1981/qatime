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

  resources :positions, only: [:index, :show]

  namespace :manager do
    resources :positions, only: [:index, :show] do
      resources :items, shallow: true
    end
  end

  namespace :station do
    resources :workstations, only: [] do
      resources :banner_items
      resources :choiceness_items do
        member do
          post :ajax_course_select
        end
      end
      resources :teacher_items
      resources :topic_items
      resources :replay_items
    end
  end

  resources :positions do
    resources :teacher_items, only: [:index, :new, :create, :edit, :update, :destroy], shallow: true
    resources :live_studio_course_items, only: [:new, :create, :edit, :update, :destroy], shallow: true
    resources :banner_items, only: [:index, :new, :create, :edit, :update, :destroy], shallow: true
    resources :choiceness_items, only: [:index, :new, :create, :edit, :update, :destroy], shallow: true
    resources :replay_items, only: [:index, :new, :create, :edit, :update, :destroy], shallow: true
    resources :items, only: [:new, :create], shallow: true
  end

  post 'choiceness_items/:id/ajax_course_select' => 'choiceness_items#ajax_course_select', as: :ajax_course_select
end
