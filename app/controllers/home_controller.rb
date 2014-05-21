class HomeController < ApplicationController
  layout 'application_home'
  def index
    if signed_in?
      redirect_to user_home_path
    end
  end
end
