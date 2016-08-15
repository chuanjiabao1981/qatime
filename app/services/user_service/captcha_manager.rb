module UserService
  class CaptchaManager
    def self.instance_and_notice(type, send_to)
      code = ::Util.random_code
      Rails.logger.debug("The Code Is: #{code}") unless Rails.env.production?

      unless Rails.env.testing?
        SmsWorker.perform_async(SmsWorker::SEND_CAPTCHA, mobile: send_to, captcha: code) if 'mobile' == type
        EmailWorker.perform_async(EmailWorker::CHANGE_EMAIL_CAPTCHA, email: send_to, code: code) if 'email' == type
      end

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
