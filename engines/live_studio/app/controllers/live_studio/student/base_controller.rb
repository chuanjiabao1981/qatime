require_dependency "live_studio/application_controller"

module LiveStudio
  module Student
    class BaseController < ApplicationController
      layout 'student_home_new'

      before_action :set_student

      private
      def set_student
        @student = ::Student.find(params[:student_id] || params[:id])
        @owner = @student
        @student
      end
    end
  end
end
