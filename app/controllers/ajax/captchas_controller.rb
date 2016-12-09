class Ajax::CaptchasController < ApplicationController
  skip_before_action :authorize
  # 生成验证码，并发送邮件或者短信
  def create
    # Util.random_code
    # code = UserService::CaptchaManager.instance_and_notice(params[:send_type], params[:send_to], params[:edit_type])
    # captcha_key = "captcha-#{params[:send_to]}"
    # session[captcha_key] = { send_to: params[:send_to], captcha: code, expire_at: 15.minutes.since.to_i }
    UserService::CaptchaManager.new(params[:send_to]).generate_and_notice(params[:key])
    respond_to do |format|
      format.json { render json: status }
    end
  end

  def verify
    send_to = params[:send_to]
    by = params[:by]
    if params[:student_id]
      @student = Student.find(params[:student_id])
    else
      @teacher = Teacher.find(params[:teacher_id])
    end

    captcha_manager = UserService::CaptchaManager.new(send_to)
    captcha = captcha_manager.captcha_of(:send_captcha)

    if params[:captcha] == captcha
      @result = captcha
    end
    session["change-#{by}-#{send_to}"] = { result: 'ok', expire_at: 15.minutes.since.to_i } if @result

    respond_to do |format|
      format.js
    end
  end
end
