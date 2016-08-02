
module EmailUtil
  def send_message(mobile,content)
    return if ENV["RAILS_ENV"] == "test"
    uri = URI.parse('http://yunpian.com/v1/sms/send.json')

    s = Net::HTTP.post_form(uri,
                            {:apikey=>"17d598eddb405659a1640ad6fa1cc985",
                             :mobile=> mobile,
                             :text=> content
                            }
    )
    result = JSON.parse(s.body)

    if result["code"].to_i != 0
      raise StandardError ,result
    end
  end
end
class EmailWorker

  SEND_CAPTCHA                 = :send_captcha

  include Sidekiq::Worker
  include EmailUtil

  sidekiq_options :queue => :email, :retry => false, :backtrace => true
  require 'net/http'
  require 'json'

  def perform(notification_type,options={})
    send notification_type,options
  end


  private

  def send_captcha(options)
    mobile  = options["mobile"]
    captcha = options["captcha"]
    begin
      send_message(mobile,
       "【答疑时间】验证码: #{captcha}，您好，如果不是您操作，请尽快修改密码")
    rescue Exception => e
      logger.info e.message
      logger.info e.backtrace.inspect
    end
  end

    def _send_message(&block)
      begin
        yield
      rescue Exception => e
        if ENV["RAILS_ENV"] != "test"
          logger.info e.message
          logger.info e.backtrace.inspect
        else
          #测试环境
        end

      end
    end

end
