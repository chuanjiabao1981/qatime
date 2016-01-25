CourseLibrary::Engine.routes.draw do

  resources :teachers do
    resources :syllabuses
  end
  resources :syllabuses do
    resources :directories do
      resources :courses, only:[:new, :edit]
    end
  end
  resources :courses do
    resources :publications
    member do
      get 'available_customized_courses_for_publish'
      get 'customized_tutorials'
      post 'publish'
      post 'un_publish'
      post 'sync'
    end
  end

end
