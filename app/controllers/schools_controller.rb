class SchoolsController < ApplicationController
  respond_to :html

  def index
    @schools = current_user.manager? ? current_user.city.try(:schools) : School.all.order(:created_at)
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(params[:school].permit!)
    @school.city = current_user.city if current_user.manager?
    if @school.save
      redirect_to schools_path
    else
      render 'new'
    end
  end

  def show
    @school = School.find(params[:id])
  end

  def edit
    @school = School.find(params[:id])
  end
  def update
    @school = School.find(params[:id])
    if @school.update_attributes(params[:school].permit!)
      redirect_to schools_path
    else
      render 'edit'
    end
  end

  def destroy
    @school = School.find(params[:id])
    @school.destroy
    redirect_to schools_path
  end

  private
  def current_resource
    @school = School.find(params[:id]) if params[:id]
  end
end
