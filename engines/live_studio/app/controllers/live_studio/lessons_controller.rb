require_dependency "live_studio/application_controller"

module LiveStudio
  class LessonsController < ApplicationController

    def show
      @course = Course.find(params[:course_id])
      @lession = @course.find(params[:id])
    end

  end
end
