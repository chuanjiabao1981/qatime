module LiveService
  class RealtimeService
    def initialize(course)
      @course = course
    end

    # 直播详情
    def detail
      { status: live_status }
    end

    # 直播状态
    def status
      return unless score = LiveStudio Redis.current.zscore("live-list", @course.id)

    end

    # 在线用户列表
    def online_users

    end

    # 直播心跳
    def live_beat
      Redis.current.zadd("live-list", @course.id, current_timestamp)
    end

    # 用户心跳
    def user_beat(user_id)
      Redis.current.zadd("course-#{@course.id}-online-users", user_id, current_timestamp)
    end

    private

    def current_timestamp
      Time.now.to_i
    end
  end
end
