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

    def show; end

    def new
      @invitation = params[:template_id].present? ? Invitation.find(params[:template_id]).dup : Invitation.new
    end

    def edit; end

    def create
      @invitation = @manager.invitations.new(invitation_params)

      @invitation.generate_attribute(invitation_params)
      if @invitation.save
        redirect_to manager_course_invitations_path(@manager), notice: i18n_notice('created', @invitation)
      else
        render :new
      end
    end

    def update; end

    def destroy; end

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
