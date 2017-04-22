CarrierWave.configure do |config|
  config.storage :aliyun
  config.aliyun_access_id = APP_CONFIG[:aliyun_ac]
  config.aliyun_access_key = APP_CONFIG[:aliyun_ak]
  if Rails.env.production?
    config.aliyun_bucket = APP_CONFIG[:bucket_online]
    config.aliyun_internal = true
    config.aliyun_host = APP_CONFIG[:aliyun_host]
  elsif Rails.env.testing?
    config.aliyun_bucket = APP_CONFIG[:bucket_testing]
    config.aliyun_internal = true
  else
    config.aliyun_bucket = APP_CONFIG[:bucket_testing]
    config.aliyun_internal = false
  end
  config.aliyun_area = "cn-beijing"
end