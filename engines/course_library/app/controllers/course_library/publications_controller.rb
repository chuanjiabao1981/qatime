require_dependency "course_library/application_controller"

module CourseLibrary
  class PublicationsController < ApplicationController
    def index
      # @publications = Course.find(params[:id]).publications
      @publications = Course.all.count
    end

    def new
      @publications = Publication.new
    end

    def current_resource
      super
    end
  end
end
