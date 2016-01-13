CourseLibrary::Engine.routes.draw do
  resources :syllabuses
  resources :publications
  resources :courses do
    resources :publications
  end
end
