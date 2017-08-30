Resource::Engine.routes.draw do
  resources :files do
    collection do
      post :create_quotes
    end
    member do
      post :delete_quote
    end
  end
end
