Resource::Engine.routes.draw do
  resources :files do
    collection do
      post :create_quotes
    end
  end
end
