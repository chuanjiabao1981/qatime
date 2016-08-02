module APIErrors
  extend ActiveSupport::Concern

  def self.included(klass)
    klass.send(:include_errors)
  end

  VeriftyFail       = Class.new StandardError
  AuthenticateFail  = Class.new StandardError
  NoVisitPermission = Class.new StandardError
  NoGetAuthenticate = Class.new StandardError
  AccountNotlogin   = Class.new StandardError
  VersionOldError   = Class.new StandardError
  StatusChangeError = Class.new StandardError

  module ClassMethods
    def include_errors
      rescue_from :all do |e|
        Rails.logger.error "#{e.message}\n\n#{e.backtrace.join("\n")}"
        out_error(code: 2001, msg: e.message)
      end

      rescue_from VeriftyFail do |e|
        out_error(code: 1001, msg: e.message || "失败")
      end

      rescue_from NoVisitPermission do
        out_error(code: 1002, msg: "无访问权限")
      end

      rescue_from AuthenticateFail do
        out_error(code: 1003, msg: "没有访问权限，请重新登录")
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        out_error(code: 1005, msg: e.message)
      end

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        out_error(code: 1006, msg: e.message || "输入内容格式有误")
      end

      rescue_from NoGetAuthenticate do
        out_error(code: 1007, msg: "没有访问权限，请重新登录")
      end

      rescue_from AccountNotlogin do
        out_error(code: 1008, msg: "请登录券商账号")
      end

      rescue_from VersionOldError do
        out_error(code: 1009, msg: "您的应用版本过旧，请更新最新版本")
      end

      rescue_from StatusChangeError do
        out_error(code: 1010, msg: "状态无法切换")
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
