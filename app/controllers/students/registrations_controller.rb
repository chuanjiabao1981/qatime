class Students::RegistrationsController < ApplicationController
  layout 'student_home'
  before_filter 'already_signin' ,only: [:new]

  def new
    @student = Student.new
    render layout: 'application'
  end
  def create
    @student = Student.new(params[:student].permit!)
    if @student.save
      sign_in(@student)
      redirect_to groups_path
    else
      render 'new',layout: 'application'
    end
  end
  def edit
  end
  def update
    if @student.update_attributes(params[:student].permit!)
      redirect_to students_info_path(@student)
    else
      render 'edit'
    end
  end
  protected
    def current_resource
      @student = Student.find(current_user.id) if current_user
    end
  def already_signin
    if current_user
      flash[:warning] = "已登录！"
      redirect_to user_home_path
    end
  end
end
