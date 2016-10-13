module UserService
  class PushDirector
    class << self

      def push(message)
        push_params(message)
        remove_nil @push_params
        result = send_push
        status = result[:ret] == 'SUCCESS' ? :success : :failed
        message.update(sign: sign,result: result, status: status)
      end

      private
      def push_params message
        @push_params ||=
        {
            appkey: app_key,
            timestamp: "#{timestamp}",
            device_tokens: message.device_tokens.presence,
            type: message.push_type.presence,
            alias_type: message.alias_type.presence,
            alias: message.alias.presence,
            filter: message.filter.presence,
            payload: {
              body: {
                ticker: message.ticker.presence,
                title: message.title.presence,
                text: message.text.presence,
                after_open: message.after_open.presence,
                url: message.url.presence,
                activity: message.activity.presence,
                custom: message.custom.presence
              },
              display_type: message.display_type.presence
            },
            policy:{
              start_time: message.start_time.presence,
              expire_time: message.expire_time.presence,
              out_biz_no: message.out_biz_no.presence
            },
            production_mode: "#{message.production_mode == '1'}"
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

      def send_url
        push_url + "?sign=#{sign}"
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
        return if Rails.env.test?
        uri = URI.parse(send_url)
        result = Net::HTTP.post_form(uri,@push_params)
        JSON.parse(result.body)
      end
    end
  end
end