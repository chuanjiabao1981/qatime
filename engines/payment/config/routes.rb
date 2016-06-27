Payment::Engine.routes.draw do

  post :callback
  get 'notify', to: 'orders#notify'
  resource :user, only: [] do
    resources :orders, only: [:index, :show, :destroy]
  end

end
