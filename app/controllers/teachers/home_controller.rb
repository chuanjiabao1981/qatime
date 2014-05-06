class Teachers::HomeController < ApplicationController
  layout "teacher_home"
  def main
    @groups = Group.where(teacher_id: current_user.id)
  end
end
