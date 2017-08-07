Chat::Engine.routes.draw do
  resources :live_studio_courses, only: [] do
    resources :teams, only: [] do
      get :finish, on: :collection
    end
  end

  resources :teams, only: [] do
    get :members, on: :member
    get :member_visit, on: :member
    get :status, on: :member
    get :list, on: :member
  end
end
