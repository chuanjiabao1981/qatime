
module WechatUtil
  def send_message(openid,content)
    result = Wechat.api.custom_message_send Wechat::Message.to(openid).text(content)
    if result["errcode"].to_i != 0
      raise StandardError ,result
    end
  end
end
class WechatWorker

  NOTIFY                       = :notify2
  REPLY			       = :reply

  include Sidekiq::Worker
  include WechatUtil

  sidekiq_options :queue => :wechat, :retry => false, :backtrace => true
  require 'json'

  def perform(notification_type,options={})
    send notification_type,options
  end


  private
  def notify2(options)
    to        = options["to"]
    message   = options["message"]
    openid    = options["openid"]
    wechat_info  = "【答疑时间】#{to}，你好，#{message}#{Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")}，谢谢。"
    _send_message do
      send_message(openid,wechat_info)
    end
  end

  def reply(options)
    message   = options["message"]
    openid    = options["openid"]
    _send_message do
      send_message(openid,message)
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
