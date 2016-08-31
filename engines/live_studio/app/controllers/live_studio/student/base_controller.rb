require_dependency "live_studio/application_controller"

module LiveStudio
  module Student
    class BaseController < ApplicationController
      layout 'student_home_new'

      before_action :set_student

      private
      def set_student
        @current_resource = @student = ::Student.find_by(id: params[:student_id]) || current_user
      end
    end
  end
end
