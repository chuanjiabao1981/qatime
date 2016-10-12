module UserService
  class PushDirector

    PUSH_TYPE = %w()

    def push(message)
      push_params(message)
      result = send_push
      status = result[:ret] == 'SUCCESS' ? :success : :failed
      message.update(sign: sign,result: result, status: status)
    end

    private
    def send_url
      push_url + "?sign=#{sign}"
    end

    def push_params message
      @push_params ||=
        {
          appkey: app_key,
          timestamp: timestamp,
          type: message.push_type.presence || 'broadcast',
          device_tokens: message.device_tokens,
          alias_type: message.alias_type,
          alias: message.alias,
          filter: message.filter,
          payload: {
            display_type: message.display_type,
            body: {
              ticker: message.ticker,
              title: message.title,
              text: message.text,
              after_open: message.after_open,
              url: message.url,
              activity: message.activity,
              custom: message.custom
            }
          },
          policy:{
            start_time: message.start_time,
            expire_time: message.expire_time,
            out_biz_no: message.out_biz_no
          },
          production_mode: message.production_mode
        }
    end

    def sign
      @sign_str ||= Digest::MD5.hexdigest('%s%s%s%s' % ['POST', push_url, @push_params.to_json, app_master_secret])
    end

    def app_key
      PUSH_CONFIG['app_key']
    end

    def push_url
      PUSH_CONFIG['push_url']
    end

    def app_master_secret
      PUSH_CONFIG['app_master_secret']
    end

    def timestamp
      @timestamp ||= Time.now.to_i
    end

    def send_push
      result = Net::HTTP.post_form(send_url,@push_params)
      JSON.parse(result.body)
    end
  end
end