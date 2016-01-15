CourseLibrary::Engine.routes.draw do

  resources :syllabuses
  resources :syllabuses do
    resources :directories do
      resources :courses, only:[:new, :edit]
    end
  end

end
