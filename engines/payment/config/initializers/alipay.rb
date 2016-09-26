ALIPAY_CONFIG = YAML.load(File.read("#{Rails.root}/config/alipay.yml"))[Rails.env]
ALIPAY_CONFIG ||= {}.freeze

Alipay.pid = ALIPAY_CONFIG['pid']
Alipay.key = ALIPAY_CONFIG['key']
Alipay.debug_mode = ALIPAY_CONFIG['debug_mode']
