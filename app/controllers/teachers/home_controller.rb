class Teachers::HomeController < ApplicationController
  layout "teacher_home"
  def main
    @curriculums = current_user.find_or_create_curriculums
    @teacher = current_user
  end
end
