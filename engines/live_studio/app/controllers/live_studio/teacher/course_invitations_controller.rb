require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::CourseInvitationsController < Teacher::BaseController
    layout 'teacher_home_new'

    def index
      @course_invitations = @teacher.invitations.paginate(page: params[:page], per_page: 10)
    end


  end
end
