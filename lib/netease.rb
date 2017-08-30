# 网易服务接口
module Netease
  class Config < Settingslogic
    source "#{Rails.root}/config/netease.yml"
    namespace Rails.env
    load!
  end

  extend ActiveSupport::Autoload

  autoload :IM
end
