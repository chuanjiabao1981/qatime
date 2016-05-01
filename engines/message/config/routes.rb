Message::Engine.routes.draw do
  resources :customized_course do
    resources :messages do
      collection do
        post :upload_image
      end
    end
  end
end
