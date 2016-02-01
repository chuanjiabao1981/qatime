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
    resources :publications
    member do
      get 'available_customized_courses_for_publish'
      get 'customized_tutorials'
      post 'publish'
      post 'un_publish'
      post 'sync'
    end
    resources :homeworks
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
