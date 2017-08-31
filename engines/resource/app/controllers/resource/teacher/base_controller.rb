require_dependency "resource/application_controller"

module Resource
  module Teacher
    class BaseController < Resource::ApplicationController
      layout 'v1/home'
      before_action :set_teacher
      include ::LiveStudio::SessionsHelper

      private

      def set_teacher
        @teacher = ::Teacher.find(params[:teacher_id] || params[:id])
        @owner = @teacher
        @teacher
      end

      def current_resource
        @teacher ||= ::Teacher.find(params[:teacher_id] || params[:id])
      end
    end
  end
end
