class Students::HomeController < ApplicationController
  layout 'student_home'
  def main
    redirect_to questions_student_path(current_user)
  end
end
