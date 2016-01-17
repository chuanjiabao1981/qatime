require_dependency "course_library/application_controller"

module CourseLibrary
  class PublicationsController < ApplicationController
    def index
      @publications = @course.publications
    end

    def new
      @publications = Publication.new
    end

    def create
      if @course.update_attributes(params[:course].permit!)
        redirect_to course_publications_path(@course)
      else
        render 'new'
      end
    end

    def current_resource
      super
      @course = Course.find(params[:course_id])
    end
  end
end
