CourseLibrary::Engine.routes.draw do

  resources :teachers do
    resources :syllabuses
  end
  resources :syllabuses do
    resources :directories
  end
  resources :directories do
    resources :courses
  end
  resources :courses
  resources :publications
  resources :homeworks
  resources :solutions
  resources :courses do
    resources :course_publications
    member do
      delete 'mark_delete'
    end
    resources :homeworks
  end

  resources :course_publications do
    member do
      post 'sync'
    end
  end
  resources :homeworks do
    resources :solutions
    member do
      delete 'mark_delete'
    end
  end
  resources :solutions do
    member do
      delete 'mark_delete'
      get 'video'
    end
  end
end
