require_dependency "course_library/application_controller"

module CourseLibrary
  class SolutionsController < ApplicationController
    include QaFilesHelper
    respond_to :html
    def new
      @homework = Homework.find(params[:homework_id])
      @solution = @homework.solutions.build()

      @course = @homework.course
      @directory = @course.directory
      @syllabus = @directory.syllabus
      @video = Video.new()
    end

    def edit
      @solution = Solution.find(params[:id])
      @homework= @solution.homework
      @course = @homework.course
      @directory = @course.directory
      @syllabus = @directory.syllabus
      @video = Video.new()
    end

    def index
    end

    def create
      @homework = Homework.find(params[:homework_id])
      @solution = @homework.solutions.build(change_params_for_qa_files(params[:solution].permit!))
      if @solution.save
        flash[:success] = "创建成功"
      end
      respond_with @solution
    end

    def update
      @solution = Solution.find(params[:id])
      @homework= @solution.homework
      @course = @homework.course
      @directory = @course.directory
      @syllabus = @directory.syllabus
      if @solution.update(change_params_for_qa_files(params[:solution].permit!))
        flash[:success] = "更新成功"
      end
      respond_with @solution
    end

    def show
      @solution = Solution.find(params[:id])
      @homework= @solution.homework
      @course = @homework.course
      @directory = @course.directory
      @syllabus = @directory.syllabus
    end

  end
end
