require_dependency "course_library/application_controller"

module CourseLibrary
  class HomeworksController < ApplicationController
    include QaFilesHelper
    respond_to :html
    def new
      @course = Course.find(params[:course_id])
      @directory = @course.directory
      @syllabus = @directory.syllabus
      @homework = @course.homeworks.build()
    end

    def edit
      @homework = Homework.find(params[:id])
      @course = @homework.course
      @directory = @course.directory
      @syllabus = @directory.syllabus
    end

    def index
      @course = Course.find(params[:course_id])
      @homeworks = @course.homeworks
    end

    def create
      @course = Course.find(params[:course_id])
      @homework = @course.homeworks.build(change_params_for_qa_files(params[:homework].permit!))
      if @homework.save
        flash[:success] = "创建成功"
      end
      respond_with @course, @homework
    end

    def update
      @homework = Course.find(params[:id])
      @course = @homework.course
      @directory = @course.directory
      @syllabus = @directory.syllabus
      if @homework.update(change_params_for_qa_files(params[:homework].permit!))
        flash[:success] = "更新成功"
      end
      respond_with @course, @homework
    end

    def show
      @homework = Homework.find(params[:id])
      @course = @homework.course
      @directory = @course.directory
      @syllabus = @directory.syllabus
    end

    def mark_delete
      @homework = Homework.find(params[:id])
      @course = @homework.course
      @homework.course_id = nil
      if @homework.save
        flash[:success] = "删除成功"
      end
      respond_with @course
    end
  end
end
