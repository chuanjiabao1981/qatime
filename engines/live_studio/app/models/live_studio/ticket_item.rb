module LiveStudio
  class TicketItem < ActiveRecord::Base
    include AASM

    enum status: {
      unused: 0, # 未使用
      used: 1, # 已使用
      finished: 9, # 已经结账
      refunding: 98, # 退款中
      refunded: 99 # 已退款
    }

    aasm column: :status, enum: true do
      state :unused, initial: true
      state :used
      state :finished
      state :refunding
      state :refunded

      # 使用
      event :use do
        transitions from: :unused, to: :used
      end

      # 结束
      event :finish do
        transitions from: [:unused, :used], to: :finished
        transitions from: :refunding, to: :refunded
      end

      # 重新激活, 用于退款撤销
      event :active do
        transitions from: :refunding, to: :unused
      end

      # 退款
      event :refund do
        transitions from: :unused, to: :refunding
      end
    end

    belongs_to :target, polymorphic: true
    belongs_to :ticket

    scope :billingable, -> { where(status: LiveStudio::TicketItem.statuses.slice(:unused, :used).values) }
  end
end
