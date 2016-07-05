Payment::Engine.routes.draw do

  post :callback

    resources :users, only: [] do
      resources :orders, only: [:index, :show, :destroy, :notify] do
        collection do
          get :result
        end
      end
    end

  # resource :user, only: [] do
  #   resources :orders, only: [:index, :show, :destroy, :notify] do
  #     collection do
  #       get :result
  #     end
  #   end
  # end

  post :notify,to: "orders#notify"

end
