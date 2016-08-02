class Ajax::CaptchasController < ApplicationController
  # 生成验证码，并发送邮件或者短信
  def create
    # Util.random_code
    code = UserService::CaptchaManager.instance_and_notice(params[:type], params[:send_to])
    captcha_key = "captcha-#{params[:send_to]}"

    session[captcha_key] = { send_to: params[:send_to], captcha: code, expired_at: 5.minutes.since.to_i }

    edit_type = params[:edit_type]
    session[edit_type] = { step: 1 } unless session[edit_type]

    respond_to do |format|
      format.json { render json: params[:send_to], status: :accepted }
    end
  end

  def verify
    student = Student.find(params[:student_id])
    edit_type = params[:edit_type]
    captcha_key = "captcha-#{params[:send_to]}"
    @result = UserService::CaptchaManager.verify(session[captcha_key], params[:input_captcha])

    if @result
      session["params[:captcha_key]-verified"] = { result: 'ok', expired_at: 5.minutes.since.to_i }
      session[edit_type][:step] += 1
      session[edit_type] = nil if session[edit_type][:step] == 3

      redirect_to edit_student_path(student, cat: params[:cat], by: params[:by])
    else
      redirect_to edit_student_path(student, cat: params[:cat], by: params[:by])
    end
  end
end
