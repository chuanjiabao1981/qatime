module Netease
  # 聊天
  module IM
    # 聊天服务
    class Service
      GATEWAY_URL = 'https://api.netease.im'.freeze

      # 发送自定义消息
      APP_CHANNEL_CREATE_REQUIRED_PARAMS = %w(from ope to type body).freeze
      def self.send_msg(params, options = {})
        params.stringify_keys!
        required_params!(params, APP_CHANNEL_CREATE_REQUIRED_PARAMS)
        request_service("/nimserver/msg/sendMsg.action", params, options)
      end

      private_class_method

      def self.request_service(uri, body, options)
        Typhoeus.post(
          "#{GATEWAY_URL}#{uri}",
          headers: request_headers(options),
          body: body
        )
      end

      # 请求头信息
      def self.request_headers(options)
        nonce = SecureRandom.hex(16)
        cur_time = Time.now.utc.to_i.to_s
        app_secret = options.delete(:AppSecret) || NeteaseSettings.app_secret
        check_sum = Digest::SHA1.hexdigest(app_secret + nonce + cur_time)
        {
          AppKey: NeteaseSettings.app_key,
          Nonce: nonce,
          CurTime: cur_time,
          CheckSum: check_sum,
          'Content-Type' => "application/x-www-form-urlencoded;charset=utf-8"
        }.merge(options)
      end

      # 检查必须参数
      def self.required_params!(params, names)
        return unless VCloud.debug_mode?
        names.each do |name|
          warn("Netease IM Warn: missing required option: #{name}") unless params.key?(name)
        end
      end
    end
  end
end
