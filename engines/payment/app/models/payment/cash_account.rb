module Payment
  # 资金账户
  class CashAccount < ActiveRecord::Base
    has_soft_delete

    belongs_to :owner, polymorphic: true
    has_many :change_records
    has_many :recharge_records
    has_many :withdraw_change_records
    has_many :earning_records
    has_many :consumption_records
    attr_accessor :create_or_update_password, :current_password, :ticket_token

    validates :owner, presence: true

    has_secure_password validations: false

    # 可用资金
    def available_balance
      balance - frozen_balance
      # balance
    end

    # 申请提现的时候冻结资金
    def frozen(amount)
      Payment::CashAccount.transaction do
        self.frozen_balance += amount
        save!
      end
    end

    # 取消冻结资金
    def cancel_frozen(amount)
      Payment::CashAccount.transaction do
        self.frozen_balance -= amount
        save!
      end
    end

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
      amount = amount.abs
      Payment::CashAccount.transaction do
        with_lock do
          check_change!(amount)
          # self.frozen_balance += amount
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
