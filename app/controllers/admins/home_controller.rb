class Admins::HomeController < ApplicationController
  layout "admin_home"
  def main
    @teachers = User.where(role: :teacher)
  end
end
