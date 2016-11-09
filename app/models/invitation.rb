class Invitation < ActiveRecord::Base
  belongs_to :user
  belongs_to :inviter, class_name: User
  belongs_to :target, polymorphic: true

  enum status: {
    sent: 0, # 已发送
    accepted: 1, # 已接受
    refused: 2, # 已拒绝
    expired: 3, # 已过期
    cancelled: 4 # 已取消
  }

  def status_text
    I18n.t("invitations.status.#{status}")
  end

  def update_expired_invitation
    update(status: 'expired') if(!expired? && Time.now.to_i > expited_at.to_i)
  end

end
