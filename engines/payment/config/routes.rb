Payment::Engine.routes.draw do

  post :callback

  resource :user, only: [] do
    resources :orders, only: [:index, :show, :destroy]
  end

end
