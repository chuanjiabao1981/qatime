CourseLibrary::Engine.routes.draw do

  resources :syllabuses do
    resources :directories do
      resources :courses
    end
  end

  resources :courses
  resources :publications
  resources :homeworks
  resources :solutions
  resources :courses do
    resources :publications
    resources :homeworks
  end
  resources :homeworks do
    resources :solutions
  end
end
