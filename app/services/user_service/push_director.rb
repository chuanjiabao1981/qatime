module UserService
  class PushDirector
    class << self

      def push(message)
        params = remove_nil(push_params(message))
        gena_sign = sign(params)
        result = send_push(send_url(gena_sign), params)
        status = result['ret'] == 'SUCCESS' ? :success : :failed
        message.update(sign: gena_sign,result: result, status: status)
      end

      private
      def push_params message
          {
            appkey: app_key,
            timestamp: "#{timestamp}",
            device_tokens: message.device_tokens.presence,
            type: message.push_type.presence,
            alias_type: message.alias_type.presence,
            alias: message.alias.presence,
            filter: message.filter.blank? ? nil : JSON.parse(message.filter),
            payload: {
              display_type: message.display_type.presence,
              body: {
                ticker: message.ticker.presence,
                title: message.title.presence,
                text: message.text.presence,
                after_open: message.after_open.presence,
                url: message.url.presence,
                activity: message.activity.presence,
                custom: message.custom.presence,
                play_vibrate: message.play_vibrate.presence,
                play_lights: message.play_lights.presence,
                play_sound: message.play_sound.presence
              }
            },
            policy:{
              start_time: message.start_time.try(:strftime,'%Y-%m-%d %H:%M:%S'),
              expire_time: message.expire_time.try(:strftime,'%Y-%m-%d %H:%M:%S'),
              out_biz_no: message.out_biz_no.presence
            },
            production_mode: "#{message.production_mode}",
            description: "#{message.description}"
          }
      end

      def remove_nil push_params
        push_params.each do |k,v|
          if(v.class == Hash)
            remove_nil v
          elsif v.blank?
            push_params.delete(k)
          end
        end
      end

      def send_url(gena_sign)
        push_url + "?sign=#{gena_sign}"
      end

      def sign(push_params)
        Digest::MD5.hexdigest('%s%s%s%s' % ['POST', push_url, push_params.to_json, app_master_secret])
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
        Time.now.to_i
      end

      def send_push(url, push_params)
        return if Rails.env.test?
        uri = URI.parse(url)
        result = Typhoeus.post(uri,body: push_params.to_json)
        JSON.parse(result.body)
      end
    end
  end
end