module LiveStudio
  class TicketItem < ActiveRecord::Base
    include AASM

    scope :available, -> { where(status: statuses.values_at(:unused, :used, :finished)) }

    enum status: {
      unused: 0, # 未使用
      used: 1, # 已使用
      finished: 9, # 已经结账
      expired: 97, # 已过期
      refunding: 98, # 退款中
      refunded: 99 # 已退款
    }

    enum tp: {
      normal: 0, # 正常购买
      free: 1, # 免费
      taste: 2 # 试听
    }

    aasm column: :status, enum: true do
      state :unused, initial: true
      state :used
      state :finished
      state :expired
      state :refunding
      state :refunded

      # 使用
      event :use, after_commit: :increase_ticket_used_count do
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

      # 失效
      event :expire do
        transitions from: [:unused, :used, :finished], to: :expired
      end
    end

    belongs_to :target, polymorphic: true
    belongs_to :ticket
    belongs_to :user

    scope :billingable, -> { where(tp: LiveStudio::TicketItem.tps[:normal], status: LiveStudio::TicketItem.statuses.slice(:unused, :used).values) }

    private

    def increase_ticket_used_count
      Ticket.increment_counter(:used_count, ticket_id)
    end
  end
end
