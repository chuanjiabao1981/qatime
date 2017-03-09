module Payment
  class SaleTask < ActiveRecord::Base
    belongs_to :target, polymorphic: true

    enum status: {
           unstart: 0, # 未开始
           ongoing: 1, # 进行中
           closed: 2 # 已结束
         }

    # 默认开始时间排序
    default_scope { order(started_at: :desc) }
    # 考核历史
    scope :closed, -> { where(status: statuses[:closed]) }
    # 待考核
    scope :unclosed, -> { where(status: [statuses[:unstart], statuses[:ongoin]]) }

    validates :started_at, :period, presence: true
  end
end
