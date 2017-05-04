module VCloud
  # 接口服务
  module Service
    GATEWAY_URL = 'https://vcloud.163.com'.freeze

    # 获取时间段内录制视频列表
    VOD_VIDEO_LIST_REQUIRED_PARAMS = %w(cid beginTime endTime).freeze
    def self.vod_video_list(params, options = {})
      params.stringify_keys!
      required_params!(params, VOD_VIDEO_LIST_REQUIRED_PARAMS)
      request_service("/app/vodvideolist", params, options)
    end

    VIDEO_LIST_REQUIRED_PARAMS = %w(cid).freeze
    def self.video_list(params, options = {})
      params.stringify_keys!
      required_params!(params, VIDEO_LIST_REQUIRED_PARAMS)
      request_service("/app/videolist", params, options)
    end

    # 获取视频文件信息
    APP_VOD_VIDEO_GET_REQUIRED_PARAMS = %w(vid).freeze
    def self.app_vod_video_get(params, options = {})
      params.stringify_keys!
      required_params!(params, APP_VOD_VIDEO_GET_REQUIRED_PARAMS)
      request_service("/app/vod/video/get", params, options)
    end

    # 视频文件合并
    APP_VIDEO_MERGE_REQUIRED_PARAMS = %w(outputName vidList).freeze
    def self.app_video_merge(params, options = {})
      params.stringify_keys!
      required_params!(params, APP_VIDEO_MERGE_REQUIRED_PARAMS)
      request_service("/app/video/merge", params, options)
    end

    # 设置视频回调地址
    APP_RECORD_SETCALLBACK_REQUIRED_PARAMS = %w(recordClk).freeze
    def self.app_record_setcallback(params, options = {})
      params.stringify_keys!
      required_params!(params, APP_RECORD_SETCALLBACK_REQUIRED_PARAMS)
      request_service("/app/record/setcallback", params, options)
    end

    # 录制设置
    APP_CHANNEL_SET_ALWAYS_RECORD_REQUIRED_PARAMS = %w(cid needRecord format duration filename).freeze
    def self.app_channel_set_always_record(params, options = {})
      params.stringify_keys!
      required_params!(params, APP_CHANNEL_SET_ALWAYS_RECORD_REQUIRED_PARAMS)
      request_service("/app/channel/setAlwaysRecord", params, options)
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
