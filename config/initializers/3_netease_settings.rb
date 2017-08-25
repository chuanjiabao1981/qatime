# 云信配置
class NeteaseSettings < Settingslogic
  source "#{Rails.root}/config/netease.yml"
  namespace Rails.env
  load!
end
