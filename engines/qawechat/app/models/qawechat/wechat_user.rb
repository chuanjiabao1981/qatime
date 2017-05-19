module Qawechat
  class WechatUser < ActiveRecord::Base
    serialize :userinfo, JSON
    belongs_to :user, class_name: 'User'

    scope :platform_of, ->(platform) { where(appid: WechatSettings.send(platform).appid) }

    # 查询其它应用下的授权
    # 同一个微信用户在Web页面登陆过在App下登陆不需要重复绑定账户
    before_validation :load_union_user!
    def load_union_user!
      return if unionid.blank? || user_id.present?
      union_record = where("unionid = ? and openid <> ?", unionid, openid).last
      self.user = union_record.user if union_record.user
    end
  end
end
