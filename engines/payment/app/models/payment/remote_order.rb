module Payment
  class RemoteOrder < ActiveRecord::Base
    include AASM

    serialize :hold_remotes, Hash
    serialize :hold_results, Hash

    belongs_to :order, polymorphic: true


    enum status: {
           unpaid: 0, # 等待支付
           paid: 1, # 已支付
           failed: 97, # 失败
           refunded: 98, # 已退款
           closed: 99 # 已关闭
         }

    aasm column: :status, enum: true do
      state :unpaid, initial: true
      state :paid
      state :failed
      state :refunded
      state :closed


      # 支付
      event :pay do
        transitions from: :unpaid, to: :paid

        after do
          pay_order!
        end
      end

      # 已支付订单退款
      event :refund do
        transitions from: :paid, to: :refunded
      end

      # 关闭未支付订单
      event :close do
        transitions from: :unpaid, to: :closed
      end

      event :fail do
        transitions from: :unpaid, to: :failed
      end
    end

    # 应该支付金额
    def pay_money
      # 测试环境支付一分钱
      return 0.01 if Rails.env.testing? || Rails.env.development?
      amount
    end

    private

    def pay_order!
      order.pay_and_ship!
    end
  end
end
