module VCloud
  # 接口服务
  module Service
    GATEWAY_URL = 'https://vcloud.163.com'.freeze

    # 获取时间段内录制视频列表
    VOD_VIDEO_LIST_REQUIRED_PARAMS = %w(cid beginTime endTime).freeze
    def self.vod_video_list(params, options = {})
      required_params!(params, VOD_VIDEO_LIST_REQUIRED_PARAMS)
      request_service("/app/vodvideolist", params, options)
    end

    VIDEO_LIST_REQUIRED_PARAMS = %w(cid).freeze
    def self.video_list(params, options = {})
      required_params!(params, VIDEO_LIST_REQUIRED_PARAMS)
      request_service("/app/videolist", params, options)
    end

    # 检查必须参数
    def self.required_params!(params, names)
      return unless VCloud.debug_mode?
      names.each do |name|
        warn("VCloud Warn: missing required option: #{name}") unless params.key?(name)
      end
    end

    # 请求服务
    def self.request_service(uri, params, options)
      Typhoeus.post(
        "#{GATEWAY_URL}#{uri}",
        headers: request_headers(options),
        body: params.to_json
      )
    end

    # 公共参数
    def self.request_headers(options = {})
      nonce = SecureRandom.hex(32)
      cur_time = Time.now.utc.to_i.to_s
      check_sum = Digest::SHA1.hexdigest(VCloud.app_secret + nonce + cur_time)
      {
        AppKey: VCloud.app_key,
        Nonce: nonce,
        CurTime: cur_time,
        CheckSum: check_sum,
        'Content-Type' => "application/json;charset=utf-8"
      }.merge(options)
    end
  end
end
