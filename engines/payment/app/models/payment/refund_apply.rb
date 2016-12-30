module Payment
  class RefundApply < Transaction
    include AASM

    validate :validate_refund, on: :create

    # has_many :refund, as: :order
    has_one :refund_reason, foreign_key: 'payment_refund_apply_id', class_name: '::Payment::RefundReason'
    belongs_to :product, polymorphic: true
    belongs_to :user
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

      event :cancel do
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
      end
    end

    def ignored_operator(current_user)
      Payment::RefundApply.transaction do
        # todo
      end
    end

    def validate_refund
      errors.add(:amount, '退款金额过低') unless amount > 0
      errors.add(:product, '该辅导班无法申请退款') unless product.published? || product.teaching?
    end
  end
end
