module UserService
  class PushDirector
    def teacher_push

    end

    def student_push

    end

    private
    def send_url
      post 'http://msg.umeng.com/api/send?sign=mysign'
    end

    def push_params
      {
        appkey: PUSH_CONFIG[:app_key],
        timestamp: Time.now.to_i,
        type: 'broadcast'    # 广播
      }
    end
  end
end