VCLOUD_CONFIGS = YAML.load(File.read("#{Rails.root}/config/vcloud.yml"))[Rails.env]

VCloud.app_key = VCLOUD_CONFIGS['app_key']
VCloud.app_secret = VCLOUD_CONFIGS['app_secret']
VCloud.debug_mode = VCLOUD_CONFIGS['debug_mode']
