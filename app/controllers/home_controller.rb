class HomeController < ApplicationController
  layout 'application_home'
  def index
    if signed_in?
      redirect_to user_home_path
    else
      #remove after bei an
      redirect_to new_session_path
    end
  end
end
