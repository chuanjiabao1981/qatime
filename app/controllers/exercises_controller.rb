class ExercisesController < ApplicationController
  respond_to :html
  layout "application"
  include QaFilesHelper
  def new
    @exercise = Exercise.new
  end

  def create
    @exercise = @customized_tutorial.exercises.build(change_params_for_qa_files(params[:exercise]).permit!)
    @exercise.teacher = current_user
    if @exercise.save
      flash[:success] = "成功创建#{Exercise.model_name.human}"
      @exercise.notify
    end
    respond_with @customized_tutorial,@exercise
  end

  def show
    @qa_files   = @exercise.qa_files.order(:created_at => "ASC")
  end
  private
  def current_resource
    if params[:customized_tutorial_id]
      @customized_tutorial = CustomizedTutorial.find(params[:customized_tutorial_id])
      r = @customized_tutorial
    end
    if params[:id]
      @exercise = Exercise.find(params[:id])
      r = @exercise
    end
    r
  end
end
