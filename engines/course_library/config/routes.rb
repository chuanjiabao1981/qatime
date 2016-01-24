CourseLibrary::Engine.routes.draw do

  resources :syllabuses
  resources :syllabuses do
    resources :directories do
      resources :courses, only:[:new, :edit]
    end
  end
  resources :publications

  resources :courses do
    resources :publications
    member do
      get 'available_customized_courses_for_publish'
      post 'publish'
    end
  end

end
