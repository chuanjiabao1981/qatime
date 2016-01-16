require_dependency "course_library/application_controller"

module CourseLibrary
  class DirectoriesController < ApplicationController

    def show
      @directory = Directory.find(params[:id])
    end

  end
end
