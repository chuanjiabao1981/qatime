# required
WxPay.appid = WECHAT_CONFIG['pay_appid']
WxPay.key = WECHAT_CONFIG['key']
WxPay.mch_id = WECHAT_CONFIG['mch_id']

# cert, see https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
# using PCKS12 for rollback
WxPay.set_apiclient_by_pkcs12(File.read("#{Rails.root}/config/apiclient_cert.p12"), WECHAT_CONFIG['mch_id'])

# WxPay.appsecret = 'YOUR_SECRET'
# optional - configurations for RestClient timeout, etc.
WxPay.extra_rest_client_options = {timeout: 20, open_timeout: 5}