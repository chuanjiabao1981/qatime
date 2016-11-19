require_dependency "live_studio/teacher/base_controller"

module LiveStudio
  class Teacher::CourseInvitationsController < Teacher::BaseController
    layout 'teacher_home_new'

    def index
      sent_status = LiveStudio::CourseInvitation.statuses[:sent]
      @course_invitations = @teacher.invitations.where(status: sent_status).order(id: :desc).paginate(page: params[:page], per_page: 10)
    end

    # 拒绝邀请
    def destroy
      @course_invitation = @teacher.invitations.find(params[:id])
      if @course_invitation.sent?
        @course_invitation.refused!
        redirect_to live_studio.teacher_course_invitations_path(@teacher), notice: I18n.t("messages.common.success")
      else
        redirect_to live_studio.teacher_course_invitations_path(@teacher), error: I18n.t("messages.common.failed")
      end
    end
  end
end
