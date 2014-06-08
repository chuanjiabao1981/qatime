CarrierWave.configure do |config|
  config.storage :aliyun
  config.aliyun_access_id = "uwTxHd9b4GNSQUWn"
  config.aliyun_access_key = 'v0BvM2K2ClP6kqr10xWqUPZswCKH4L'
  config.aliyun_bucket = "qatime"
  config.aliyun_internal = false
  config.aliyun_area = "cn-beijing"
end