CarrierWave.configure do |config|
  config.storage :aliyun
  config.aliyun_access_id = APP_CONFIG[:aliyun_ac]
  config.aliyun_access_key = APP_CONFIG[:aliyun_ak]
  if Rails.env.production?
    config.aliyun_bucket = APP_CONFIG[:bucket_online]
  else
    config.aliyun_bucket = APP_CONFIG[:bucket_test]
  end
  config.aliyun_internal = false
  config.aliyun_area = "cn-beijing"
end