class StudentsController < ApplicationController
  respond_to :html

  def index
    @students = Student.all.order(created_at: :desc).paginate(page: params[:page],:per_page => 10)

  end
  def new
    @student = Student.new
  end
  def create
    @student = Student.new(params[:student].permit!)
    @student.build_account
    if @student.save
      if signed_in?
        respond_with @student
      else
        sign_in(@student)
        redirect_to user_home_path
      end
    else
      render 'new'
    end
  end
  def show
  end
  def edit
  end

  def update
    if @student.update_attributes(params[:student].permit!)
      redirect_to student_path(@student)
    else
      render 'edit'
    end
  end
  def search
    @students = Student.all
                .where("name =? or email = ?",params[:search][:name],params[:search][:name])
  end

  private
  def current_resource
    @student = Student.find(params[:id]) if params[:id]
  end
end
