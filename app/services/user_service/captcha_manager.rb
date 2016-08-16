module UserService
  class CaptchaManager
    def self.instance_and_notice(send_type, send_to, type)
      code = ::Util.random_code
      Rails.logger.debug("The Code Is: #{code}") unless Rails.env.production?

      # if type == "register"
      #   SmsWorker.perform_async(SmsWorker::REGISTER_CAPTCHA, mobile: send_to, captcha: code) if 'mobile' == send_type
      # else
      #   SmsWorker.perform_async(SmsWorker::SEND_CAPTCHA, mobile: send_to, captcha: code, type: type) if 'mobile' == send_type
      # end

      EmailWorker.perform_async(EmailWorker::CHANGE_EMAIL_CAPTCHA, email: send_to, code: code) if 'email' == send_type
      code
    end

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
  end
end
