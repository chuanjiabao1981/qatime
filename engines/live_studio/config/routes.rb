LiveStudio::Engine.routes.draw do
  namespace :manager do
    resources :courses
  end
end
