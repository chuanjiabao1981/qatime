Settings = Qatime::Application.config_for(:settings).deep_symbolize_keys
WechatSetting = Qatime::Application.config_for(:wechat).deep_symbolize_keys
p WechatSetting[:wap]