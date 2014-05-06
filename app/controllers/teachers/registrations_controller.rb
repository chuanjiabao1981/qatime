class Teachers::RegistrationsController < ApplicationController
  layout "teacher_home"
  respond_to :html
  def edit
    @teacher = Teacher.find(current_user.id)
  end
  def update
    @teacher = Teacher.find(params[:id])

    if @teacher.update_attributes(params[:teacher].permit!)
      redirect_to teachers_registration_path(@teacher)
    else
      render 'edit'
    end
  end

  def show
    @teacher = Teacher.find(current_user.id)
  end
end
