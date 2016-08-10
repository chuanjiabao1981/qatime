require_dependency "live_studio/application_controller"

module LiveStudio
  class HelpsController < ApplicationController
    layout 'teacher_home_new'
    before_action :current_resource


    private
    def current_resource
      @resource ||= set_teacher
    end

    def set_teacher
      @teacher = ::Teacher.find_by(id: params[:teacher_id]) || current_user
    end
  end
end
