require_dependency "course_library/application_controller"

module CourseLibrary
  class PublicationsController < ApplicationController
    def index
      # @publications = Course.find(params[:id]).publications
      @publications = Course.all.count
    end

    def current_resource
      super
      1234
    end
  end
end
