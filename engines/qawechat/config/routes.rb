Qawechat::Engine.routes.draw do
  resource :wechat, only: [:show, :create]
  resources :wechat_users, only: [:new, :create, :show, :destroy]
  resources :users, only: [:new, :create] do
    member do
      put :remove_wechat
    end
  end
end
