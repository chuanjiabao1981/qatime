class Wap::UsersController < Wap::ApplicationController

  def new
    @student = Student.new
  end

  def create
    @student = Student.new(create_params).register_columns_required!.captcha_required!
    @student.accept = params[:accept].presence
    captcha_manager = UserService::CaptchaManager.new(create_params[:login_mobile])
    @student.captcha = captcha_manager.captcha_of(:register_captcha)
    @student.build_account
    if @student.save
      session.delete("captcha-#{create_params[:login_mobile]}")
      sign_in(@student) unless signed_in?
      redirect_to wap_after_sign_in_path
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:student).permit(:login_mobile, :captcha_confirmation, :password, :password_confirmation, :accept)
  end

end
