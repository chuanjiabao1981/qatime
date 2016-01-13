require_dependency "course_library/application_controller"

module CourseLibrary
  class PublicationsController < ApplicationController
    def index
      @publications = Course.find(params[:id]).publications
    end
  end
end
