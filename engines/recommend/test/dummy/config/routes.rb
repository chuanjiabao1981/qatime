Rails.application.routes.draw do

  mount Recommend::Engine => "/recommend"
end
