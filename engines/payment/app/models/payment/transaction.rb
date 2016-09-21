module Payment
  class Transaction < ActiveRecord::Base
    has_soft_delete

    extend Enumerize

    belongs_to :user

    enumerize :source, in: { web: 0, app: 1 }, default: :web

    private

    # 生成流水号
    before_create :generate_transaction_no
    def generate_transaction_no
      self.transaction_no = Util.random_order_no unless transaction_no
    end

    protected

    def pay_fail!(key, e)
    end
  end
end
