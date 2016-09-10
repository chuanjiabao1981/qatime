require_dependency "live_studio/application_controller"

module LiveStudio
  module Teacher
    class BaseController < ApplicationController
      layout 'teacher_home_new'
      before_action :set_teacher
      include ::LiveStudio::SessionsHelper

      private
      # def current_resource
      #   @resource ||= set_teacher
      # end

      def set_teacher
        @teacher = ::Teacher.find(params[:teacher_id] || params[:id])
      end
    end
  end
end
