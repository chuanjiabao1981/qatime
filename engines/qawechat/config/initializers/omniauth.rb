Rails.application.config.middleware.use OmniAuth::Builder do
  provider :wechat, WECHAT_CONFIG['appid'], WECHAT_CONFIG['secret']
  provider :wechat2, WECHAT_CONFIG['appid'], WECHAT_CONFIG['secret']
end
