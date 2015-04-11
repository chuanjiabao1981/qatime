class TeachersController < ApplicationController
  respond_to :html

  def index
    @teachers = Teacher.all.order(:created_at).paginate(page: params[:page],:per_page => 10)
  end

  def new
    @teacher = Teacher.new
  end

  def create
    @teacher = Teacher.new(params[:teacher].permit!)
    @teacher.save
    respond_with @teacher
  end

  def show
    @teacher = Teacher.find(params[:id])
    @curriculums = @teacher.find_or_create_curriculums

  end

  def edit
    @teacher = Teacher.find(params[:id])
  end

  def update
    @teacher = Teacher.find(params[:id])

    @teacher.update_attributes(params[:teacher].permit!)

    respond_with @teacher
  end
  def search
    @teachers = Teacher.all
    .where("name =? or email = ?",params[:search][:name],params[:search][:name]).paginate(page: params[:page],:per_page => 10)
    render 'index'
  end
end
