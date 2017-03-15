# 转账
module Payment
  class WithdrawRemit < ActiveRecord::Base
    extend Enumerize

    belongs_to :target, polymorphic: true

    validates :pay_type, :pay_username, :remit_at, presence: true
    validates :target, presence: true
    validates_presence_of :pic, message: I18n.t('view.payment/withdraw_remit.pic_valid')
    # 人工转账1, 1个时系统自动转账2
    enum pay_type: { manual: 1, auto: 2 }
    enumerize :pay_type, in: { manual: 1, auto: 2 }

    mount_uploader :pic, PictureUploader

    before_create :pay_withdraw

    private

    def pay_withdraw
      Payment::Withdraw.find(target.id).pay! if target.is_a?(Payment::Withdraw) && target.may_pay?
    end
  end
end
