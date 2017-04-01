module Payment
  # 退款
  class Refund < Transaction
    include AASM

    attr_accessor :tmp_operator

    validate :validate_refund, on: :create
    after_create :init_apply

    has_many :weixin_refunds, as: :order
    has_one :refund_reason, foreign_key: 'payment_refund_apply_id', class_name: '::Payment::RefundReason'
    belongs_to :product, polymorphic: true
    belongs_to :seller, polymorphic: true
    belongs_to :user
    belongs_to :order, foreign_key: 'transaction_no', primary_key: 'transaction_no', class_name: '::Payment::Order'
    scope :filter, ->(keyword){keyword.blank? ? nil : where('transaction_no ~* ?', keyword).presence ||
      where(user: User.where('name ~* ?',keyword).presence || User.where('login_mobile ~* ?',keyword))}

    before_validation :set_seller, on: :create
    def set_seller
      self.seller = order.seller if order
    end

    enum status: {
      init: 0,
      allowed: 1,
      submited: 2,
      # ignored: 2,
      # cancel: 3,
      # refunded: 4
      refunded: 10, # 已退款
      ignored: 97, # 已拒绝
      canceled: 98, # 已取消
      failed: 99 # 退款失败
    }
    enum pay_type: %w(cash bank alipay weixin account)

    aasm column: :status, enum: true do
      state :init, initial: true
      state :allowed
      state :submited
      state :refunded
      state :ignored
      state :canceled
      state :failed

      event :allow, before: :allow_operator, after_commit: :cash_transfer! do
        transitions from: [:init], to: :allowed
      end

      event :refuse, before: :ignored_operator do
        transitions from: [:init], to: :ignored
      end

      event :cancel, after: :cancel_apply do
        transitions from: [:init], to: :canceled
      end

      # 退款到余额可以直接转账
      event :transfer do
        before do
          self.pay_at = Time.now
        end
        transitions from: [:allowed], to: :refunded, if: :account?
      end

      # 提交第三方退款申请
      event :submit do
        transitions from: [:allowed], to: :submited, unless: :account?
      end

      # 第三方通知退款成功
      event :success do
        before do
          self.pay_at = Time.now
        end
        transitions from: [:submited], to: :refunded
      end

      # 第三方通知退款成功
      event :fail do
        transitions from: [:submited], to: :failed
      end
    end

    # 销售收入增加额(分成利润)
    def profit_amount
      product.try(:calculate_sell_percentage).presence || 0.0
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

    def cash_transfer!
      BusinessService::RefundManager.new(self).billing
    end

    def pay_and_ship!
      success!
    end

    def remote_refund!
      raise Payment::InvalidOperation, "不支持的提现方式" unless weixin?
      submit!
      remote = weixin_refunds.create!(
        amount: amount,
        status: :unpaid,
        order_no: transaction_no
      )
      remote.remote_refund
    end

    def allow_by!(operator)
      Payment::Refund.transaction do
        operator_record('init', 'allowed', operator)
        allow!
      end
    end

    def refuse_by!(operator)
      Payment::Refund.transaction do
        operator_record('init', 'ignored', operator)
        refuse!
      end
    end

    private

    def allow_operator
      Payment::Refund.transaction do
        # buy_ticket 变更为已退款（refunded）
        # order 变更为已退款
        # 退出云信群组
        # 创建管理员审核操作记录
        # 系统财务账户资金变动
        # 创建系统通知
        user.live_studio_buy_tickets.where(product: product).refunding.first.try(:refunded!)
        order.allow_refund!
        leave_chat_team
        LiveService::OrderNotificationSender.new(order).notice(PaymentOrderNotification::ACTION_REFUND_SUCCESS)
      end
    end

    def ignored_operator
      Payment::Refund.transaction do
        # buy_ticket 变更为可用（active）
        # 创建管理员审核操作记录
        # 订单状态变更
        # 创建系统通知
        user.live_studio_buy_tickets.where(product: product).refunding.first.try(:active!)
        order.try(:refuse_refund!)
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
      user.live_studio_buy_tickets.where(product: product).active.first.try(:refunding!)
      order.try(:refund!)
    end

    def cancel_apply
      # buy_ticket 变更为可用（active）
      # 订单状态 变更
      user.live_studio_buy_tickets.where(product: product).refunding.first.try(:active!)
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
