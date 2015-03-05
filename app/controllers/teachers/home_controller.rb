class Teachers::HomeController < ApplicationController
  layout "teacher_home"
  def main
    @groups = Group.where(teacher_id: current_user.id)
    @curriculums = current_user.find_or_create_curriculums
  end
end
