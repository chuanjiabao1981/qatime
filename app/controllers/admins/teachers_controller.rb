class Admins::TeachersController < ApplicationController
  layout "admin_home"
  respond_to :html

  def index
    @teachers = Teacher.all
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(params[:teacher].permit!)
    @teacher.save
    respond_with :admins,@teacher
  end

  def show
    @teacher = Teacher.find(params[:id])
  end

  def edit
    @teacher = Teacher.find(params[:id])
  end

  def update
    @teacher = Teacher.find(params[:id])

    @teacher.update_attributes(params[:teacher].permit!)

    respond_with :admins,@teacher


  end
end
