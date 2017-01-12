module LiveStudio
  class TicketItem < ActiveRecord::Base
    enum status: {
      unused: 0, # 未使用
      used: 1, # 已使用
      refunding: 98, # 退款中
      refunded: 99 # 已退款
    }

    belongs_to :lesson
  end
end
