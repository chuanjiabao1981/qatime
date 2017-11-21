Social::Engine.routes.draw do
  namespace :station do
    resources :workstations, only: [] do
      resources :feeds, only: [:index]
    end
  end
end
