require_dependency "course_library/application_controller"

module CourseLibrary
  class CoursesController < ApplicationController
    include QaFilesHelper
    respond_to :html
    def new
      @directory = Directory.find(params[:directory_id])
      @syllabus = @directory.syllabus
      @course = @directory.courses.build()
      @video = Video.new()
    end

    def edit
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      @video = Video.new()
    end

    def index
      @directory = Directory.find(params[:directory_id])
      @courses = @directory.courses
    end
    def create
      @directory = Directory.find(params[:directory_id])
      @syllabus = @directory.syllabus
      @course = @directory.courses.build(change_params_for_qa_files(params[:course].permit!))
      if @course.save
        flash[:success] = "创建成功"
      end
      respond_with  @directory, @course
      #respond_with @course
    end

    def update
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      if @course.update(change_params_for_qa_files(params[:course].permit!))
        flash[:success] = "更新成功"
      end
      respond_with @directory, @course
    end

    def destroy
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      @course.destory
      redirect_to syllabus_directory_path(@syllabus, @directory)
    end

    def show
      @course = Course.find(params[:id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      # @customized_tutorials = @course.customized_tutorials
    end
    def available_customized_courses_for_publish
      @available_customized_courses = @course.available_customized_course_for_publish
      @course_publication           = @course.course_publications.new
    end

    def customized_tutorials
      @customized_tutorials = @course.customized_tutorials
    end
    def publish
      params[:course][:available_customized_course_ids].delete("")
      Course::Publish.new(params[:course][:available_customized_course_ids],@course).call
      flash[:success] = t("view.course_library/course.publish_success")
      redirect_to customized_tutorials_course_path(@course)
    end

    def un_publish
      if Course::UnPublish.new(params[:customized_tutorial_id]).call
        flash[:success] = t("view.course_library/course.un_publish_success")
      else
        flash[:warning]    = t("view.course_library/course.un_publish_fail")
      end
      redirect_to customized_tutorials_course_path(@course)
    end

    def sync
      if Course::Sync.new(params[:customized_tutorial_id]).call
        flash[:success] = t("view.course_library/course.sync_success")
      else
        flash[:warning] = t("view.course_library/course.sync_fail")
      end
      redirect_to customized_tutorials_course_path(@course)
    end

    def mark_delete
      @course.directory = nil
      if @course.save
        flash[:success] = "删除成功"
      end
      respond_with @directory
    end

private
    def current_resource
      if params[:id]
        @course = Course.find(params[:id])
        @directory = @course.directory
        @syllabus = @directory.syllabus
        @teacher = @syllabus.author
        @course
      else
        @directory = Directory.find(params[:directory_id])
        @syllabus = @directory.syllabus
        @teacher = @syllabus.author
        @directory
      end
    end
  end
end
