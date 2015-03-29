class StudentsController < ApplicationController
  def index
    @students = Student.all.paginate(page: params[:page],:per_page => 10)

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
