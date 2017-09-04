Resource::Engine.routes.draw do
  resources :files do
    collection do
      post :create_quotes
    end
    member do
      post :delete_quote
    end
  end

  scope module: :teacher do
    resources :teachers, only: [] do
      resources :files
    end
  end
end
