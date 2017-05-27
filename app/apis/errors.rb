module APIErrors
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.send(:include_errors)
  end

  NotLogin              = Class.new StandardError
  AuthenticateExpired   = Class.new StandardError
  NoVisitPermission     = Class.new StandardError
  AuthenticateFail      = Class.new StandardError
  VersionOldError       = Class.new StandardError
  ClientInvalid         = Class.new StandardError
  StatusChangeError     = Class.new StandardError
  CaptchaError          = Class.new StandardError
  ValueOverflow         = Class.new StandardError
  WithdrawExisted       = Class.new StandardError
  PasswordInvalid       = Class.new StandardError
  PaymentPasswordBlank  = Class.new StandardError
  TokenInvalid          = Class.new StandardError
  CourseTasteLimit      = Class.new StandardError
  PasswordDissatisfy    = Class.new StandardError
  TryManyTimes          = Class.new StandardError
  BalanceNotEnough      = Class.new StandardError

  module ClassMethods
    def include_errors
      rescue_from :all do |e|
        Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
        out_error(code: 9999, msg: e.message)
      end

      rescue_from NotLogin do |e|
        out_error(code: 1001, msg: e.message || "未登录")
      end

      rescue_from AuthenticateExpired do
        out_error(code: 1002, msg: "授权过期")
      end

      rescue_from NoVisitPermission do
        out_error(code: 1003, msg: "无访问权限")
      end

      rescue_from AuthenticateFail do
        out_error(code: 1004, msg: "授权失败")
      end

      rescue_from VersionOldError do
        out_error(code: 2001, msg: "您的应用版本过旧，请更新最新版本")
      end

      rescue_from ClientInvalid do
        out_error(code: 2002, msg: "不支持的客户端")
      end

      rescue_from CaptchaError do |e|
        out_error(code: 2003, msg: e.message || "无效的验证码")
      end

      rescue_from ValueOverflow do |e|
        out_error(code: 2004, msg: e.message || "数值溢出")
      end

      rescue_from PasswordInvalid do |e|
        out_error(code: 2005, msg: e.message || "密码验证失败")
      end

      rescue_from PaymentPasswordBlank do |e|
        out_error(code: 2006, msg: e.message || "当前没有设置支付密码")
      end

      rescue_from TokenInvalid do |e|
        out_error(code: 2007, msg: e.message || "授权Token无效")
      end

      rescue_from PasswordDissatisfy do |e|
        out_error(code: 2008, msg: e.message || "支付密码设置时间不足2小时")
      end

      rescue_from TryManyTimes do |e|
        out_error(code: 2009, msg: e.message || "超过重试次数")
      end

      rescue_from BalanceNotEnough do |e|
        out_error(code: 2010, msg: e.message || "余额不足")
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        out_error(code: 3001, msg: e.message || "输入内容格式有误")
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        out_error(code: 3002, msg: e.message)
      end

      rescue_from WithdrawExisted do |e|
        out_error(code: 3003, msg: e.message || '当前有未完成的提现申请')
      end

      rescue_from CourseTasteLimit do |e|
        out_error(code: 3004, msg: e.message || '无法试听')
      end
    end
  end
end

module Grape::Middleware
  class Error
    # 将默认错误返回状态码改为200
    def out_error(message = {})
      error = {
        message: message,
        status: 200
      }
      error_response(error)
    end
  end
end
