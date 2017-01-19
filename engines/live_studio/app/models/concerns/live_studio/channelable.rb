module LiveStudio
  module Channelable
    extend ActiveSupport::Concern

    VCLOUD_HOST = 'https://vcloud.163.com'.freeze

    private
    def vcloud_headers
      app_secret = VCLOUD_CONFIG['AppSecret']
      nonce = SecureRandom.hex 32
      cur_time = Time.now.utc.to_i.to_s

      check_sum = Digest::SHA1.hexdigest(app_secret + nonce + cur_time)

      {
        AppKey: VCLOUD_CONFIG['AppKey'],
        Nonce: nonce,
        CurTime: cur_time,
        CheckSum: check_sum,
        'Content-Type' => "application/json;charset=utf-8"
      }
    end
  end
end