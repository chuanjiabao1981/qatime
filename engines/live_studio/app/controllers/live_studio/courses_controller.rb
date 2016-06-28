require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    def index
      @courses = Course.for_sell.includes(:teacher).all
    end

    def taste
      @course = Course.find(params[:id])
      @course.taste_tickets.find_or_create_by(student_id: current_user.id)
    end
  end
end
