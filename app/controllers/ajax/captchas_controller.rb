class Ajax::CaptchasController < ApplicationController
  # 生成验证码，并发送邮件或者短信
  def create
    # Util.random_code
    code = UserService::CaptchaManager.instance_and_notice(params[:type], params[:send_to])
    captcha_key = "captcha-#{send_to}"
    session[captcha_key] = { send_to: params[:send_to], captcha: code, expired_at: 5.minutes.since.to_i }
  end

  def verify
    @result = UserService::CaptchaManager.verify(session[params[:captcha_key]], params[:code])
    session["params[:captcha_key]-verified"] = { result: 'ok', expired_at: 5.minutes.since.to_i } if @result
  end
end
