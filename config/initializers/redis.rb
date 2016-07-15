module DataCache
  class << self
    def redis
      @redis ||= Redis.connect
    end
  end
end