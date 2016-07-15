Chat::Engine.routes.draw do
  resources :live_studio_courses, only: [] do
    get 'teams/finish', to: "teams#finish"
    get 'teams/members', to: "teams#members"
    get 'teams/member_visit', to: "teams#member_visit"
  end
end
