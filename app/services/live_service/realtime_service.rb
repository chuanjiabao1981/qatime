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
      Redis.current.zadd("live_studio/course-#{@course_id}-online-users", timestamp, user_id)
    end

    # 更新直播信息
    def update_live(lesson, board, camera)
      live_attrs = { id: lesson.id, name: lesson.name, status: lesson.status, board: board, camera: camera, t: timestamp }
      Redis.current.hmset("live_studio/course-#{@course_id}-live-info", *live_attrs.to_a.flatten)
      live_attrs
    end

    # 直播心跳
    # 更新时间, 不更新直播信息
    def touch_live
      Redis.current.hmset("live_studio/course-#{@course_id}-live-info", :t, timestamp)
    end

    class << self
      def courses_status(ids)
        Redis.current.hgetall("#{LiveStudio::Course.model_name.cache_key}/#{Date.today.to_s}").slice(ids.map(&:to_s))
      end

      def lessons_status(ids)
        Redis.current.hgetall("#{LiveStudio::Lesson.model_name.cache_key}/#{Date.today.to_s}").slice(ids.map(&:to_s))
      end

      # 更新缓存状态
      def update_status(obj, live_status)
        Redis.current.hmset("#{obj.model_name.cache_key}/#{Date.today.to_s}",  obj.id, live_status)
      end

      # 更新课程直播状态
      def update_lesson_live(lesson)
        update_status(lesson, lesson.status)
        update_status(lesson.course, lesson.status)
      end
    end

    private

    # 时间戳
    def timestamp
      Time.now.to_i
    end

    # 辅导班直播信息
    def live_info
      result = Redis.current.hgetall("live_studio/course-#{@course_id}-live-info")
      result = init_live if result.blank?
      result
    end

    # 观看用户列表
    def online_users
      Redis.current.zrange("live_studio/course-#{@course_id}-online-users", 0, 2.minutes.ago.to_i)
    end

    # 如果查询不到直播缓存信息立即初始化缓存
    def init_live
      update_live(LiveStudio::Course.find(@course_id).current_lesson, 0, 0)
    end
  end
end
