class Students::InfosController < ApplicationController
  layout 'student_home'

  def show
    @student = current_user
  end
end
