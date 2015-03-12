class Teachers::RegistrationsController < ApplicationController
  layout "teacher_home"
  respond_to :html

  def new
    @teacher = Teacher.new
    render layout: 'application'
  end

  def create
    @teacher = Teacher.new(params[:teacher].permit!)
    if @teacher.save
      sign_in(@teacher)
      redirect_to user_home_path
    else
      render 'new',layout: 'application'
    end
  end
  def edit
  end
  def update

    if @teacher.update_attributes(params[:teacher].permit!)
      redirect_to teachers_registration_path(@teacher)
    else
      render 'edit'
    end
  end

  def show
  end

  protected
  def current_resource
    @teacher = Teacher.find(current_user.id) if current_user
  end
end
