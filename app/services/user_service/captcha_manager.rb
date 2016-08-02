module UserService
  class CaptchaManager
    def self.instance_and_notice(type, send_to)
      code = ::Util.random_code
      Rails.logger.debug("The Code Is: #{code}") unless Rails.env.production?
      SmsWorker.perform_async(SmsWorker::SEND_CAPTCHA, mobile: send_to, captcha: code) if 'mobile' == type
      # TODO
      EmailWorker.perform_async(EmailWorker::SEND_CAPTCHA, email: send_to, code: code) if 'email' == type
      code
    end

    def self.verify(obj, code)
      obj[:captcha] == code && obj.expired_at.to_i > 5.minutes.ago.to_i
    end
  end
end
