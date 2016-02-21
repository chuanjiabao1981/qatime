require_dependency "course_library/application_controller"

module CourseLibrary
  class CoursePublicationsController < ApplicationController

    def index
      @course_publications = @course.course_publications
    end

    def new
      @course_publication = @course.course_publications.build
    end

    def create
      @course_publication = @course.course_publications.build(params[:course_publication].permit!)
      if @course_publication.save
        flash[:success] = t("view.course_library/course_publication.publish_success")
        return redirect_to course_course_publications_path(@course)
      else
        render 'new'
      end
    end

    private
    def current_resource
      t = nil
      if params[:course_id]
        @course = Course.find(params[:course_id])

        t        = @course
      end
      if params[:id]
        @course_publication = CoursePublication.find(params[:id])
        @course             = @course_publication.course
        t                   = @course_publication
      end
      @directory = @course.directory
      @syllabus = @directory.syllabus
      @teacher = @syllabus.author
      t
    end
  end
end
