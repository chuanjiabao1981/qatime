module Payment
  # 资金账户
  class CashAccount < ActiveRecord::Base
    has_soft_delete

    belongs_to :owner, polymorphic: true
    has_many :change_records
    has_many :recharge_records # 充值记录
    has_many :withdraw_records # 提现记录
    has_many :earning_records # 收入记录
    has_many :consumption_records # 消费记录
    has_many :refund_records # 退款记录
    has_many :split_pay_reacords # 分账支出记录
    has_many :advance_charge_records # 代收记录

    attr_accessor :create_or_update_password, :current_password, :ticket_token

    validates :owner, presence: true

    has_secure_password validations: false

    # 充值
    def recharge(amount, target)
      Payment::CashAccount.transaction do
        with_lock do
          change(:recharge_records, amount.abs, target: target, billing: nil, summary: "账户充值")
        end
      end
    end

    # 提现
    def withdraw(amount, target)
      Payment::CashAccount.transaction do
        with_lock do
          change(:withdraw_change_records, -amount.abs, target: target, billing: nil, summary: "账户提现")
          self.frozen_balance -= amount
          save!
        end
      end
    end

    # 退款
    def refund(amount, target)
      Payment::CashAccount.transaction do
        with_lock do
          change(:refund_records, -amount.abs, target: target, billing: nil, summary: "用户申请退款")
          self.total_expenditure += amount.abs
          save!
        end
      end
    end

    # 收到退款
    def receive(amount, target)
      Payment::CashAccount.transaction do
        with_lock do
          change(:earning_records, amount.abs, target: target, billing: nil, summary: "系统退款")
          save!
        end
      end
    end

    # 收入
    def earning(amount, target, billing, summary)
      Payment::CashAccount.transaction do
        with_lock do
          change(:earning_records, amount.abs, target: target, billing: billing, summary: summary)
          self.total_income += amount.abs
          save!
        end
      end
    end

    # 支出
    def consumption(amount, target, billing, summary, options = {})
      options ||= {}
      Payment::CashAccount.transaction do
        with_lock do
          change(:consumption_records, -amount.abs, options.merge(target: target, billing: billing, summary: summary))
          self.total_expenditure += amount.abs
          save!
        end
      end
    end

    # 验证token
    def validate_ticket_token(cate, token, object)
      token && token == Redis.current.get("#{object.model_name.cache_key}/#{object.id}/#{cate}")
    end

    # 支出之前检查可用资金
    def consumption_with_check(amount, target, billing, summary, options = {})
      options ||= {}
      Payment::CashAccount.transaction do
        with_lock do
          check_change!(amount.abs) if options[:change_type].to_s == 'account' # 余额支出需要检查可用资金
          consumption_without_check(amount, target, billing, summary, options)
        end
      end
    end
    alias_method_chain :consumption, :check

    # 冻结资金
    def freeze_cash(amount)
      # amount = amount.abs
      Payment::CashAccount.transaction do
        with_lock do
          check_change!(amount)
          self.frozen_balance += amount
          save!
        end
      end
    end

    # 是否设置了支付密码, 用户接口
    def password?
      password_digest.present?
    end

    # 使用支付密码更新
    def update_with_password(params, *options)
      current_password = params.delete(:current_password)
      result = if authenticate(current_password)
                 update_attributes(params, *options)
               else
                 assign_attributes(params, *options)
                 valid?
                 errors.add(:current_password, current_password.blank? ? :blank : :invalid)
                 false
               end
      self.password = nil
      result
    end

    # 使用授权token更新
    def update_with_token(cate, params, *options)
      ticket_token = params.delete(:ticket_token)
      result =
        if ticket_token == Redis.current.get("#{model_name.cache_key}/#{id}/#{cate}")
          update_attributes(params, *options)
        else
          assign_attributes(params, *options)
          valid?
          errors.add(:ticket_token, ticket_token.blank? ? :blank : :invalid)
          false
        end
      self.ticket_token = nil
      result
    ensure
      Redis.current.del("#{model_name.cache_key}/#{id}/#{cate}")
    end

    def balance_attrs
      {
        before: balance_was,
        after: balance,
        available_before: available_balance_was,
        available_after: available_balance,
        deposit_before: deposit_balance_was,
        deposit_after: deposit_balance,
        unavailable_before: unavailable_balance_was,
        unavailable_after: unavailable_balance
      }
    end

    # 记录明细
    def record_detail!(relation_name, amount, options = {})
      attrs = { amount: amount, different: amount }.merge(options)
      attrs[:target] ||= options[:billing][:target] if options[:billing]
      # 明细摘要，便于管理员对账阅读
      attrs[:summary] ||= (options[:billing_item] || options[:billing]).try(:summary)
      send(relation_name).create!(balance_attrs.merge(attrs))
    end

    private

    # 资金变动
    # force可以透支消费
    def change(records_chain, amount, attrs)
      return if amount.zero?
      after = balance + amount
      change_record = send(records_chain).create!(
        attrs.merge(
          before: balance,
          after: after,
          amount: amount,
          different: amount,
          owner: owner
        )
      )
      self.balance += change_record.different
      save!
    end

    def check_change!(amount)
      raise Payment::BalanceNotEnough, "可用资金不足" if available_balance < amount
    end
  end
end
