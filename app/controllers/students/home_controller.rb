class Students::HomeController < ApplicationController
  layout 'student_home'
  def main
    redirect_to homeworks_student_path(current_user)
  end
end
