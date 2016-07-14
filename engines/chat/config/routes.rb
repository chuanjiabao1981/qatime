Chat::Engine.routes.draw do
  resources :live_studio_courses, only: [] do
    get 'teams/finish', to: "teams#finish"
  end
end
