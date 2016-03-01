require_dependency "course_library/application_controller"

module CourseLibrary
  class CoursePublicationsController < ApplicationController

    def index
      @course_publications = @course.course_publications
    end

    def new
      @course_publication = @course.course_publications.build
      @course_publication_form = CoursePublicationForm.new
    end

    def create
      a = CoursePublicationForm.new(params[:course_publication])
      puts a.to_json
      @course_publication = @course.course_publications.build(params[:course_publication].permit!)
      if @course_publication.save
        CustomizedTutorialService::CourseLibrary::CreateFromPublication.new(@course_publication).call
        flash[:success] = t("view.course_library/course_publication.publish_success")
        return redirect_to course_course_publications_path(@course)
      else
        render 'new'
      end
    end

    def edit
    end

    def update
      service_respond = CourseLibrary::CoursePublicationService::Update.new(@course_publication,params[:course_publication].permit!).call
      if service_respond.success?
        return redirect_to course_course_publications_path(@course)
      else
        flash.now[:warning] = service_respond.errors.join(" ")
        render 'edit'
      end
    end

    def destroy
      if @course_publication.customized_tutorial and
          not CustomizedTutorialService::Fee::AnyComponentCharged.new(@course_publication.customized_tutorial).judge?
        @course_publication.destroy
        flash[:success] = t("view.course_library/course_publication.un_publish_success")
      else
        flash[:warning]    = t("view.course_library/course_publication.un_publish_fail")
      end
      redirect_to course_course_publications_path(@course)
    end

    def sync
      if @course_publication.customized_tutorial
        CustomizedTutorialService::CourseLibrary::SyncWithTemplate.new(@course_publication.customized_tutorial).call
      end
      flash[:success] = t("view.course_library/course_publication.sync_success")

      redirect_to course_course_publications_path(@course)

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
