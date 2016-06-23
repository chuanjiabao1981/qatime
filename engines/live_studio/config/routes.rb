LiveStudio::Engine.routes.draw do
  get 'courses/index'

  get 'courses/teate'

  get 'courses_controller/index'

  resources :courses, only: [:index] do
    resources :orders, only: [:new, :create, :pay, :show] # 下单
    member do
      get 'taste' # 试听
    end

    resources :lessons, only: [:show] do
      member do
        get :play
      end
    end
  end

  namespace :manager do
    resources :courses
  end

  namespace :teacher do
    resources :courses, only: [:index, :show, :edit, :update] do
      resources :lessons
      member do
        patch :sync_channel_streams
      end
    end
  end

  namespace :student do
    resources :courses, only: [:index, :show]
  end
end
