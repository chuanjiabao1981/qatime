require_dependency "live_studio/application_controller"

module LiveStudio
  class Workstation::CourseInvitationsController < ApplicationController
    layout :current_user_layout

    before_action :set_owner

    def index
      @invitations = @workstation.invitations.includes(:user)
      @invitations = @invitations.includes(:user).where("users.subject" => params[:subject]) if params[:subject].present?
      @invitations = @invitations.where(status: LiveStudio::CourseInvitation.statuses[params[:status]]) if params[:status].present?
      @invitations = @invitations.paginate(page: params[:page])
    end

    def new
      @invitation = if params[:template_id].present?
                      invitation = @workstation.invitations.find(params[:template_id])
                      invitation.user_mobile = invitation.user.login_mobile
                      invitation.dup
                    else
                      LiveStudio::CourseInvitation.new
                    end
    end

    def create
      @invitation = @workstation.invitations.new(invitation_params.merge(inviter: current_user, type: 'LiveStudio::CourseInvitation'))

      @invitation.generate_attribute(invitation_params)
      if @invitation.save
        redirect_to user_course_invitations_path(@current_user), notice: i18n_notice('created', @invitation)
      else
        render :new
      end
    end

    def cancel
      invitation = @workstation.invitations.find(params[:id])
      if invitation.update(status: 'cancelled')
        redirect_to user_course_invitations_path(@current_resource)
      end
    end

    private
    def set_owner
      @owner ||= User.find(params[:user_id])
      @workstation ||= @owner.manager? ? @owner.workstations.first : @owner.workstation
      @owner
    end

    def current_resource
      @current_resource ||= set_owner
    end

    def invitation_params
      params.require(:course_invitation).permit(
        :user_mobile, :teacher_percent, :expited_day
      )
    end

  end
end
