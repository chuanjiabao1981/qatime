module Payment
  # 资金账户
  class CashAccount < ActiveRecord::Base
    has_soft_delete

    belongs_to :owner, polymorphic: true
    has_many :change_records

    attr_accessor :create_or_update_password, :current_password, :ticket_token

    validates :owner, presence: true

    has_secure_password validations: false

    # 验证token
    def validate_ticket_token(cate, token, object)
      token && token == Redis.current.get("#{object.model_name.cache_key}/#{object.id}/#{cate}")
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

    # 记录明细
    # direction 资金变动方向 in 入账; out 出账
    # 总收入和总消费保存依赖调用方法, 改值可以根据change records计算得出
    def record_detail!(amount, transaction, direction, options = {})
      diff = options[:different] || amount
      record = change_records.create!(transaction: transaction, type: transaction.change_record_type(direction), amount: amount, different: diff)
      self.total_income += record.amount if record.is_a?(Payment::EarningRecord) # 如果是收入记录增加总收入
      self.total_expenditure += record.amount if record.is_a?(Payment::ConsumptionRecord) # 如果是消费记录增加总消费
      record
    end
  end
end
