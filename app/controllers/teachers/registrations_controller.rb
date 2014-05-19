class Teachers::RegistrationsController < ApplicationController
  layout "teacher_home"
  respond_to :html
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
    @teacher = Teacher.find(current_user.id)
  end
end
