module Payment
  class SaleTask < ActiveRecord::Base
    include AASM

    belongs_to :target, polymorphic: true

    enum status: {
           unstart: 0, # 未开始
           ongoing: 1, # 进行中
           closed: 2 # 已结束
         }

    aasm column: :status, enum: true do
      state :unstart, initial: true
      state :ongoing
      state :closed

      event :start do
        transitions from: :unstart, to: :ongoing
      end

      event :close do
        before do
          self.closed_at = Time.now
        end
        transitions from: :ongoing, to: :closed
      end
    end

    # 默认开始时间排序
    default_scope { order(started_at: :desc) }
    # 待考核
    scope :unclosed, -> { where(status: [statuses[:unstart], statuses[:ongoing]]) }

    validates :started_at, :period, presence: true

    validates :period, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 12 }
    validates :charge_percentage, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 100 }
    validates :target_balance, numericality: { greater_than_or_equal_to: 0 }

    validates :target, presence: true

    # 验证考核时间是否跟其它考核冲突
    validate :check_task_time

    # 统计销售完成进度
    def report
      return unless ongoing?
      self.result_balance = sell_amount - refund_amount
      self.result = result_balance >= target_balance
      self.charge_balance = charge_proportion * left_amount
    end

    def sell_amount
      @sell_amount = Payment::Order.valid_order.where(seller: target).where(pay_at: (started_at..ended_at)).sum(:amount)
    end

    def refund_amount
      @refund_amount = Payment::Refund.where(status: Payment::Refund.statuses[:refunded], seller: target).where(pay_at: (started_at..ended_at)).sum(:amount)
    end

    # 未完成销售额
    def left_amount
      [target_balance - result_balance, 0].max
    end

    # 考核期总收入
    def total_income
      target.cash_account.earning_records.where(created_at: (started_at..ended_at)).sum(:amount)
    end

    # 未考核的收入记录
    def uncheck_earning_records
      target.cash_account.earning_records.where(created_at: (started_at..ended_at)).where(assess_billing_id: nil)
    end

    # 单个结算收入
    def income_for_assess_billing(assess_billing_id)
      target.cash_account.earning_records.where(assess_billing_id: assess_billing_id).sum(:amount)
    end

    private

    def charge_proportion
      charge_percentage.to_f / 100
    end

    # 计算结束时间
    before_validation :cal_ended_at
    def cal_ended_at
      return if started_at.blank? || period.blank?
      self.ended_at = (started_at + period.months - 1.days).end_of_day if started_at_changed? || period_changed?
    end

    before_validation :copy_charge_percentage, on: :create
    def copy_charge_percentage
      self.charge_percentage = target.platform_percentage
    end

    def check_task_time
      return if started_at.blank? || period.blank?
      # 开始时间不能在别的考核周期内
      errors.add(:started_at, '考核时间冲突') if Payment::SaleTask.where('started_at <= ? and ended_at >= ? and id <> ?', started_at, started_at, id.to_i).where(target: target).exists?
      # 结束时间不能在别的考核周期内
      errors.add(:period, '考核时间冲突') if Payment::SaleTask.where('started_at <= ? and ended_at >= ? and id <> ?', ended_at, ended_at, id.to_i).where(target: target).exists?
      # 考核周期内不能有其它的开始时间
      errors.add(:started_at, '考核时间冲突') if Payment::SaleTask.where(started_at: (started_at..ended_at)).where('id <> ?', id.to_i).where(target: target).exists?
      # 考核周期内不能有其它的结束时间
      errors.add(:started_at, '考核时间冲突') if Payment::SaleTask.where(ended_at: (started_at..ended_at)).where('id <> ?', id.to_i).where(target: target).exists?
    end
  end
end
