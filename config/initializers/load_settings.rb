Settings = Qatime::Application.config_for(:settings).deep_symbolize_keys
WechatSetting = Qatime::Application.config_for(:wechat).deep_symbolize_keys

WechatSetting[:wap_cert] = [File.read(File.expand_path("../../#{WechatSetting[:wap][:cert]}", __FILE__)), WechatSetting[:wap][:mch_id]]
WechatSetting[:app_cert] = [File.read(File.expand_path("../../#{WechatSetting[:app][:cert]}", __FILE__)), WechatSetting[:app][:mch_id]]
WechatSetting[:web_cert] = [File.read(File.expand_path("../../#{WechatSetting[:web][:cert]}", __FILE__)), WechatSetting[:web][:mch_id]]
