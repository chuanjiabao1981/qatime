class CoursesController < ApplicationController
  respond_to :html
  def index
    @courses = Course.all.order(updated_at: :desc)
  end
  def new
    @course = Course.init
  end
  def create
    @course = Course.init(params[:course].permit!)
    @course.save
    respond_with @course
  end
  def show
    @course = Course.find(params[:id])
  end
  def edit
    @course = Course.find(params[:id])
  end
  def update
    @course = Course.find(params[:id])
    @course.update_attributes(params[:course].permit!)
    respond_with @course
  end
end
