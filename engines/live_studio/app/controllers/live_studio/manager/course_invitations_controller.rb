require_dependency "live_studio/manager/base_controller"

module LiveStudio
  class Manager::CourseInvitationsController < Manager::BaseController
    before_action :set_manager

    def index
      @invitations = @manager.invitations
      @invitations = @invitations.includes(:user).where("users.subject"=>params[:subject]) if params[:subject].present?
      @invitations = @invitations.where(status: LiveStudio::CourseInvitation.statuses[params[:status]]) if params[:status].present?
      @invitations = @invitations.paginate(page: params[:page], per_page: 10)
    end

    def new
      @invitation = params[:template_id].present? ? LiveStudio::CourseInvitation.find(params[:template_id]).dup : LiveStudio::CourseInvitation.new
    end

    def create
      @invitation = @manager.invitations.new(invitation_params)

      @invitation.generate_attribute(invitation_params)
      if @invitation.save
        redirect_to manager_course_invitations_path(@manager), notice: i18n_notice('created', @invitation)
      else
        render :new
      end
    end

    def cancel
      invitation = @manager.invitations.find(params[:id])

      if invitation.update(status: 'cancelled')
        redirect_to manager_course_invitations_path(@manager)
      end
    end

    private

    def set_manager
      @manager = ::Manager.find(params[:manager_id])
    end

    def invitation_params
      params.require(:course_invitation).permit(
        :login_mobile, :teacher_percent, :expited_day
      )
    end

  end
end
