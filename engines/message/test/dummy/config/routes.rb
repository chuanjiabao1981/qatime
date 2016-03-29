Rails.application.routes.draw do

  mount Message::Engine => "/message"
end
