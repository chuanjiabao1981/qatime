require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    def index
      @courses = Course.for_sell.includes(:teacher).all
    end

    def taste
    end
  end
end
