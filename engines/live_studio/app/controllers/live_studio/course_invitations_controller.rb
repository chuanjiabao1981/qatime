module LiveStudio
  class CourseInvitationsController < ApplicationController
    layout :current_user_layout

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
        :user_mobile, :teacher_percent, :expited_day
      )
    end
  end
end
