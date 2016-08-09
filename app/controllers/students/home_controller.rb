class Students::HomeController < ApplicationController
  layout 'student_home_new'
  def main
    redirect_to homeworks_student_path(current_user)
  end
end
