class Ajax::CaptchasController < ApplicationController
  # 生成验证码，并发送邮件或者短信
  def create
    # Util.random_code
    code = UserService::CaptchaManager.instance_and_notice(params[:send_type], params[:send_to])
    captcha_key = "captcha-#{params[:send_to]}"

    session[captcha_key] = { send_to: params[:send_to], captcha: code, expire_at: 5.minutes.since.to_i }

    edit_type = params[:edit_type]
    session[edit_type] = { step: 1 } unless session[edit_type]

    respond_to do |format|
      format.json { render json: status }
    end
  end

  def verify
    @student = Student.find(params[:student_id])
    # binding.pry
    edit_type = params[:edit_type]
    send_to = params[:send_to]
    captcha_key = "captcha-#{send_to}"
    @result = UserService::CaptchaManager.verify(session[captcha_key], params[:captcha])
    session["change-#{edit_type}-#{send_to}"] = { result: 'ok', expire_at: 5.minutes.since.to_i } if @result
    respond_to do |format|
      format.js
    end
  end
end
