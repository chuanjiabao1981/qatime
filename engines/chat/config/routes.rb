Chat::Engine.routes.draw do
  resources :live_studio_courses, only: [] do
    get 'teams/finish', to: "teams#finish"
    get 'teams/members', to: "teams#members"
  end
end
