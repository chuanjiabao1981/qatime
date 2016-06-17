class HomeController < ApplicationController
  layout 'application_home'
  def index
    redirect_to user_home_path if signed_in?
  end
end
