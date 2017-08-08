module Qatime
  # 工具类
  module Util
    # 顺序执行
    def self.sequence_exec(key, t)
      t ||= Time.now.to_i
      t = t.to_i
      return if safe_cache(key, t) > t
      yield if block_given?
    end

    # 安全缓存，用于缓存时间戳
    def self.safe_cache(key, value)
      last = Redis.current.get(key)
      Redis.current.setex(key, 5.minutes, value) if last.to_i < value
      last || value
    end
  end
end
