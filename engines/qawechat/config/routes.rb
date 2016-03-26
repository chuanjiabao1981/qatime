Qawechat::Engine.routes.draw do
  resource :wechat, only: [:show, :create]
  resources :wechat_users, only: [:new, :create, :show, :destroy]
  resource :wechat_voice, only: [:show, :create]
end
