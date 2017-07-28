module LiveService
  class GroupRealtimeService
    def initialize(group_id)
      @group_id = group_id
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
      auto_expire_cache("live_studio/group-#{@group_id}-online-users") do
        Redis.current.zadd("live_studio/group-#{@group_id}-online-users", timestamp, user_id)
      end
    end

    # 更新直播信息
    def update_live(event, board, camera)
      live_attrs = { id: event.id, name: event.name, status: event.status, board: board, camera: camera, t: timestamp }
      touch_live(live_attrs)
    end

    # 更新时间, 不更新直播信息
    def touch_live(attrs = nil)
      attrs ||= { t: timestamp }
      auto_expire_cache("live_studio/group-#{@group_id}-online-users") do
        Redis.current.hmset("live_studio/group-#{@group_id}-live-info", *attrs.to_a.flatten)
      end
      attrs
    end

    class << self
      def groups_status(ids)
        Redis.current.hgetall("#{LiveStudio::Course.model_name.cache_key}/#{Date.today}").slice(ids.map(&:to_s))
      end

      def event_status(ids)
        Redis.current.hgetall("#{LiveStudio::Lesson.model_name.cache_key}/#{Date.today}").slice(ids.map(&:to_s))
      end

      # 更新缓存状态
      def update_status(obj, live_status)
        Redis.current.hmset("#{obj.model_name.cache_key}/#{Date.today}", obj.id, live_status)
      rescue e
        p e
      ensure
        auto_expire_cache("#{obj.model_name.cache_key}/#{Date.today}")
      end

      # 更新课程直播状态
      def update_lesson_live(event)
        update_status(lesson, event.status)
        update_status(event.group, event.status)
      rescue e
        p e
      end
    end

    private

    # 时间戳
    def timestamp
      Time.now.to_i
    end

    # 辅导班直播信息
    def live_info
      result = Redis.current.hgetall("live_studio/group-#{@group_id}-live-info")
      result = init_live if result.blank?
      result
    end

    # 观看用户列表
    def online_users
      Redis.current.zrangebyscore("live_studio/group-#{@group_id}-online-users", 2.minutes.ago.to_i, 1.minutes.since.to_i)
    end

    # 如果查询不到直播缓存信息立即初始化缓存
    def init_live
      update_live(LiveStudio::Group.find(@group_id).current_event, 0, 0)
    end

    # 自动清理缓存
    def auto_expire_cache(kee)
      yield if block_given?
      Redis.current.expire(kee, 5.minutes)
    end
  end
end
