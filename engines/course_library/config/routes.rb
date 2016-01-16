CourseLibrary::Engine.routes.draw do

  resources :syllabuses do
    resources :directories do
      resources :courses, only:[:new, :edit]
    end
  end

  resources :publications
  resources :courses do
    resources :publications
  end

end
