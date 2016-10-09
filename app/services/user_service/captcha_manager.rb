module UserService
  class CaptchaManager
    # def self.instance_and_notice(send_type, send_to, type)
    #   code = ::Util.random_code
    #   Rails.logger.debug("The Code Is: #{code}") unless Rails.env.production?

    #   if type == "register"
    #     SmsWorker.perform_async(SmsWorker::REGISTER_CAPTCHA, mobile: send_to, captcha: code) if 'mobile' == send_type
    #   else
    #     SmsWorker.perform_async(SmsWorker::SEND_CAPTCHA, mobile: send_to, captcha: code, type: type) if 'mobile' == send_type
    #   end

    #   EmailWorker.perform_async(EmailWorker::CHANGE_EMAIL_CAPTCHA, email: send_to, captcha: code) if 'email' == send_type
    #   code
    # end

    def self.verify(obj, code)
      obj[:captcha] == code && obj[:expire_at] > Time.now.to_i
    end

    def self.captcha_of(obj)
      return if obj.blank? || obj[:expire_at] < Time.now.to_i
      obj[:captcha]
    end

    def self.expire?(obj)
      obj.blank? || obj[:expire_at] < Time.now.to_i
    end

    def initialize(send_to)
      @send_to = send_to
    end

    def notice_type
      @send_to.include?("@") ? :email_notice : :sms_notice
    end

    def generate_and_notice(key)
      code = ::Util.random_code
      Rails.logger.debug("The Code Is: #{code}") unless Rails.env.production?
      Redis.current.setex("#{key}:#{@send_to}", 10.minutes, code)
      send(notice_type, code, key)
      code
    end

    def captcha_of(key)
      Redis.current.get("#{key}:#{@send_to}")
    end

    def expire_captch(key)
      Redis.current.del("#{key}:#{@send_to}") if captcha_of(key)
    end

    private

    # 短信通知
    def sms_notice(code, key)
      SmsWorker.perform_async(sms_notice_tpl(key), mobile: @send_to, captcha: code)
    end

    # 邮件通知
    def email_notice(code, key)
      EmailWorker.perform_async(email_notice_tpl(key), email: @send_to, captcha: code)
    end

    # 邮件通知模板
    def email_notice_tpl(key)
      case key.to_sym
        when :change_email_captcha
          EmailWorker::CHANGE_EMAIL_CAPTCHA
        when :get_password_back
          EmailWorker::GET_PASSWORD_BACK
      end
    end

    # 短信通知模板
    def sms_notice_tpl(key)
      case key.to_sym
      when :register_captcha
        SmsWorker::REGISTER_CAPTCHA
      when :send_captcha
        SmsWorker::SEND_CAPTCHA
      when :get_password_back
        SmsWorker::GET_PASSWORD_BACK
      when :withdraw_cash
        SmsWorker::WITHDRAW_CASH
      end
    end
  end
end
