require 'vcloud/service'

# 网易视频云接口库
module VCloud
  @debug_mode = true

  class << self
    attr_accessor :app_key, :app_secret, :debug_mode

    def debug_mode?
      @debug_mode
    end
  end
end
