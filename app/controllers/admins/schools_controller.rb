class Admins::SchoolsController < ApplicationController
  layout "admin_home"

  respond_to :html
  def index
    @schools = School.all
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(params[:school].permit!)
    @school.save
    respond_with :admins,@school
  end

  def show
    @school = School.find(params[:id])
  end

  def edit
    @school = School.find(params[:id])
  end

  def update
    @school = School.find(params[:id])
    @school.update_attributes(params[:school].permit!)
    respond_with :admins,@school
  end

  def destroy
    @school = School.find(params[:id])
    @school.destroy
    redirect_to schools_path
  end
end
