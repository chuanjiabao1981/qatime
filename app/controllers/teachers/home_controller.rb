class Teachers::HomeController < ApplicationController
  def main
    redirect_to user_home_path
  end
end
