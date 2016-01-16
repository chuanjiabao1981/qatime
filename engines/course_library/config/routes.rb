CourseLibrary::Engine.routes.draw do

  resources :syllabuses do
    resources :directories do
      resources :courses
    end
  end

  resources :courses
  resources :publications
  resources :courses do
    resources :publications
  end

end

