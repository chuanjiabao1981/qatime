class SettingsController < ApplicationController
  def create
    @setting = NotificationSetting.find_or_create_by(owner: current_user, key: 'live_studio/course')
    @setting.update_attributes(setting_params)
    redirect_to current_user.teacher? ? live_studio.schedules_teacher_path(current_user) : live_studio.schedules_student_path(current_user)
  end

  private

  def setting_params
    params.require(:setting).permit(:notice, :email, :message, :before_hours, :before_minutes)
  end
end
