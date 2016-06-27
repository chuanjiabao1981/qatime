# required
WxPay.appid = WECHAT_CONFIG['appid']
WxPay.key = WECHAT_CONFIG['secret']
WxPay.mch_id = WECHAT_CONFIG['mch_id']

# cert, see https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=4_3
# using PCKS12 for rollback
# WxPay.set_apiclient_by_pkcs12(File.read(pkcs12_filepath), pass)

# optional - configurations for RestClient timeout, etc.
WxPay.extra_rest_client_options = {timeout: 2, open_timeout: 3}