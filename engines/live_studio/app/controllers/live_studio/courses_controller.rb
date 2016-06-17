require_dependency "live_studio/application_controller"

module LiveStudio
  class CoursesController < ApplicationController
    def index
      @courses = Course.includes(:teacher).all
    end

    def teate
    end
  end
end
