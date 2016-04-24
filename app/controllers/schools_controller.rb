class SchoolsController < ApplicationController
  respond_to :html

  def index
    @schools = School.order(:created_at)
                     .paginate(page: params[:page], per_page: 10)
  end

  def new
    @school = School.new
  end

  def create
    @school = School.new(params[:school].permit!)
    if @school.save
      redirect_to schools_path
    else
      render 'new'
    end
  end

  def show
    load_school
  end

  def edit
    load_school
  end

  def update
    load_school
    if @school.update_attributes(params[:school].permit!)
      redirect_to schools_path
    else
      render 'edit'
    end
  end

  def destroy
    load_school
    @school.destroy
    redirect_to schools_path
  end

  private

  def current_resource
    load_school if params[:id]
  end

  def load_school
    @school = School.find params[:id]
  end
end
