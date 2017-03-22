module LiveService
  class RealtimeService
    def initialize(course_id)
      @course_id = course_id
    end

    # 直播详情
    def live_detail(user_id = nil)
      # 如果是用户获取
      online_notify(user_id) if user_id.present?
      {
        live_info: live_info,
        online_users: online_users,
        timestamp: timestamp # 当前系统时间，用于校验数据过期
      }
    end

    # 用户更新在线通知
    def online_notify(user_id)
      Redis.current.zadd("live_studio/course-#{@course_id}-online-users", user_id, current_timestamp)
    end

    # 更新直播信息
    def update_live(lesson, board, camera)
      Redis.current.hmset("live_studio/course-#{@course_id}-live-info",
                          *lesson.attributes.slice(:id, :name).to_a,
                          :t, timestamp, :board, board, :camera, camera)
    end

    # 直播心跳
    # 更新时间, 不更新直播信息
    def touch_live
      Redis.current.hmset("live_studio/course-#{@course_id}-live-info", :t, timestamp)
    end

    private

    # 时间戳
    def timestamp
      Time.now.to_i
    end

    # 辅导班直播信息
    def live_info
      Redis.current.hgetall("live_studio/course-#{@course_id}-live-info")
    end

    # 观看用户列表
    def online_users
      Redis.current.zrange("course-#{@course_id}-online-users", 0, -1)
    end

  end
end
