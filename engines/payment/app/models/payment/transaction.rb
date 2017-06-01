module Payment
  class Transaction < ActiveRecord::Base
    has_soft_delete
    attr_accessor :statistics_days

    extend Enumerize

    belongs_to :user
    belongs_to :owner, polymorphic: true

    enumerize :source, in: { web: 0, student_app: 1, wap: 2, teacher_app: 3 }, default: :web
    enumerize :statistics_days, in: { week: 0, month: 1, month2: 2, month3: 3, month6: 6, year: 12 }, default: :week

    protected

    def pay_fail!(key, e)
    end

    def pay_and_ship!
      pay!
    end

    private

    # 生成流水号
    before_create :generate_transaction_no
    def generate_transaction_no
      self.transaction_no = Util.random_order_no unless transaction_no
    end
  end
end
