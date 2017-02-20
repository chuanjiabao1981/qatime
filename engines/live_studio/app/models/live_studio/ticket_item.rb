module LiveStudio
  class TicketItem < ActiveRecord::Base
    enum status: {
      unused: 0, # 未使用
      used: 1, # 已使用
      settled: 9, # 已经结账
      refunding: 98, # 退款中
      refunded: 99 # 已退款
    }

    belongs_to :lesson
    belongs_to :ticket

    scope :billingable, -> { where(status: LiveStudio::TicketItem.statuses.slice(:unused, :used).values) }
  end
end
