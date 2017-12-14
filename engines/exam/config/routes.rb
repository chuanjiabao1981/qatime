Exam::Engine.routes.draw do
  resources :papers, only: [:index, :show] do
    resources :orders, only: [:new, :create]
  end

  # 考试结果
  resources :results, only: [:index, :show]

  resources :junior_papers, only: [] do
    resources :orders, only: [:new, :create]
  end

  namespace :station do
    resources :workstations, only: [] do
      resources :papers do
        member do
          patch :publish
        end
      end

      resources :package_topics, only: [:edit, :update]
      resources :group_topics, only: [:edit, :update]
      resources :topics, only: [:edit, :update]
      resources :listen_answer_topics, only: [:edit, :update]
      resources :listen_report_topics, only: [:edit, :update]
      resources :listen_speak_topics, only: [:edit, :update]
    end
  end

  namespace :student do
    resources :students, only: [] do
      resources :papers
    end
  end
end
