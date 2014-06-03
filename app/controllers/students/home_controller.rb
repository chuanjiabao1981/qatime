class Students::HomeController < ApplicationController
  layout 'student_home'
  def main
    redirect_to students_registration_path(current_user)
  end
end
