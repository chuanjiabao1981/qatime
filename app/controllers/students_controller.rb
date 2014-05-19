class StudentsController < ApplicationController
  before_filter 'already_signin' ,only: [:new]

  def new
    @student = Student.new
  end
  def create
    @student = Student.new(params[:student].permit!)
    if @student.save
      sign_in(@student)
      redirect_to groups_path
    else
      render 'new'
    end
  end
  def already_signin
    if current_user
      #flash[:warning] = "已登录！"
      redirect_to root_path
    end
  end
end
