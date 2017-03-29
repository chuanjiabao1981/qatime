class Tools
  def self.with_lock(key, timeout = nil, &block)
    lock_time = Time.now.to_i
    yield block if Redis.current.setnx(key, lock_time)
  ensure
    if timeout
      Redis.current.expire(key, timeout)
    else
      Redis.current.del(key)
    end
  end
end
