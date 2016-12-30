module Payment
  class RefundApply < Transaction
    include AASM

    validate :validate_refund, on: :create
    after_create :init_apply

    # has_many :refund, as: :order
    has_one :refund_reason, foreign_key: 'payment_refund_apply_id', class_name: '::Payment::RefundReason'
    belongs_to :product, polymorphic: true
    belongs_to :user
    belongs_to :order, foreign_key: 'transaction_no', primary_key: 'transaction_no', class_name: '::Payment::Order'
    scope :filter, ->(keyword){keyword.blank? ? nil : where('transaction_no ~* ?', keyword).presence ||
      where(user: User.where('name ~* ?',keyword).presence || User.where('login_mobile ~* ?',keyword))}

    enum status: %w(init success ignored cancel refunded)
    enum pay_type: %w(cash bank alipay wechat account)

    aasm column: :status, enum: true do
      state :init, initial: true
      state :success
      state :ignored
      state :cancel
      state :refunded

      event :allow, before: :allow_operator do
        transitions from: [:init], to: :success
      end

      event :ignored, before: :ignored_operator do
        transitions from: [:init], to: :refused
      end

      event :cancel, after: :cancel_apply do
        transitions from: [:init], to: :cancel
      end

      event :pay do
        transitions from: [:success], to: :refunded
      end
    end

    def status_text
      I18n.t("enum.payment/refund_apply.status.#{status_text}")
    end

    def pay_type_text
      I18n.t("enum.payment/refund_apply.pay_type.#{pay_type}")
    end

    def self.pay_type_text(pay_type)
      I18n.t("enum.payment/refund_apply.pay_type.#{pay_type}")
    end

    private

    def allow_operator(current_user)
      Payment::RefundApply.transaction do
        # todo
        # buy_ticket 变更为已退款（refunded）
        # 辅导班购买人数-1
        # 退出云信群组
        # 创建退款记录
        # 退款申请状态变更为success
        # 创建管理员审核操作记录
      end
    end

    def ignored_operator(current_user)
      Payment::RefundApply.transaction do
        # todo
        # buy_ticket 变更为可用（active）
        # 退款申请状态变更为忽略（ignored）
        # 创建管理员审核操作记录
      end
    end

    def validate_refund
      errors.add(:amount, '退款金额过低') unless amount > 0
      errors.add(:product, '该辅导班无法申请退款') unless product.published? || product.teaching?
    end

    def init_apply
      # todo
      # buy_ticket 变更为退款中（rufunding），无法继续查看直播。

    end

    def cancel_apply
      # todo
      # buy_ticket 变更为可用（active）
      # 退款申请状态变更为取消（cancel）
    end
  end
end
