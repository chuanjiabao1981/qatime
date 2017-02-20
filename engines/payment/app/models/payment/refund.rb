module Payment
  class Refund < Transaction
    include AASM

    validate :validate_refund, on: :create
    after_create :init_apply

    has_many :weixin_refunds, as: :order
    has_one :refund_reason, foreign_key: 'payment_refund_apply_id', class_name: '::Payment::RefundReason'
    belongs_to :product, polymorphic: true
    belongs_to :user
    belongs_to :order, foreign_key: 'transaction_no', primary_key: 'transaction_no', class_name: '::Payment::Order'
    scope :filter, ->(keyword){keyword.blank? ? nil : where('transaction_no ~* ?', keyword).presence ||
      where(user: User.where('name ~* ?',keyword).presence || User.where('login_mobile ~* ?',keyword))}

    enum status: %w(init success ignored cancel refunded)
    enum pay_type: %w(cash bank alipay weixin account)

    aasm column: :status, enum: true do
      state :init, initial: true
      state :success
      state :ignored
      state :cancel
      state :refunded

      event :allow, before: :allow_operator, after: :account_auto_pay do
        transitions from: [:init], to: :success
      end

      event :refuse, before: :ignored_operator do
        transitions from: [:init], to: :ignored
      end

      event :cancel, after: :cancel_apply do
        transitions from: [:init], to: :cancel
      end

      event :pay do
        transitions from: [:success], to: :refunded
      end
    end

    def status_text
      I18n.t("enum.payment/refund.status.#{status}")
    end

    def pay_type_text
      I18n.t("enum.payment/refund.pay_type.#{pay_type}")
    end

    def self.pay_type_text(pay_type)
      I18n.t("enum.payment/refund.pay_type.#{pay_type}")
    end

    def pay_and_ship!
      pay!
    end

    private
    def account_auto_pay
      # 如果退款是支付到余额中,则用户余额变动
      # 如果微信支付,则创建微信退款订单, 并调用微信退款接口
      account? && user.cash_account!.receive(amount, self)
      weixin? && weixin_refunds.create(
        amount: amount,
        status: :unpaid,
        order_no: transaction_no
      ).remote_refund
    end

    def allow_operator(current_user)
      Payment::Refund.transaction do
        # buy_ticket 变更为已退款（refunded）
        # order 变更为已退款
        # 退出云信群组
        # 创建管理员审核操作记录
        # 系统财务账户资金变动
        # 创建系统通知
        user.live_studio_buy_tickets.where(course: product).refunding.first.try(:refunded!)
        order.allow_refund!
        leave_chat_team
        operator_record('init', 'success', current_user)
        CashAdmin.current!.cash_account!.refund(amount, self)
        LiveService::OrderNotificationSender.new(order).notice(PaymentOrderNotification::ACTION_REFUND_SUCCESS)
      end
    end

    def ignored_operator(current_user)
      Payment::Refund.transaction do
        # buy_ticket 变更为可用（active）
        # 创建管理员审核操作记录
        # 订单状态变更
        # 创建系统通知
        user.live_studio_buy_tickets.where(course: product).refunding.first.try(:active!)
        order.try(:refuse_refund!)
        operator_record('init', 'ignored', current_user)
        LiveService::OrderNotificationSender.new(order).notice(PaymentOrderNotification::ACTION_REFUND_FAIL)
      end
    end

    def validate_refund
      errors.add(:amount, '退款金额过低') unless amount > 0
      errors.add(:product, '该辅导班无法申请退款') unless product.published? || product.teaching?
    end

    def init_apply
      # buy_ticket 变更为退款中（rufunding），无法继续查看直播。
      # order 状态变更为退款中（rufunding）
      user.live_studio_buy_tickets.where(course: product).active.first.try(:refunding!)
      order.try(:refund!)
    end

    def cancel_apply
      # buy_ticket 变更为可用（active）
      # 订单状态 变更
      user.live_studio_buy_tickets.where(course: product).refunding.first.try(:active!)
      order.try(:refuse_refund!)
    end

    # 操作记录
    def operator_record(from, to, current_user)
      ActionRecord.create(
        actionable: self,
        operator: current_user,
        from: from,
        to: to,
        event: "refund",
        name: "refund"
      )
    end

    # 离开群组
    def leave_chat_team
      chat_team = product.try(:chat_team)
      user_account = user.try(:chat_account)
      return if chat_team.blank? || user_account.blank?
      LiveService::ChatTeamManager.new(chat_team).remove_members([user_account])
    end
  end
end
