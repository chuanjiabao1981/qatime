module LiveStudio
  class CustomizedGroup < Group
    has_many :scheduled_lessons, class_name: 'ScheduledLesson', foreign_key: :group_id, dependent: :destroy
    has_many :offline_lessons, class_name: 'OfflineLesson', foreign_key: :group_id, dependent: :destroy
    has_many :instant_lessons, class_name: 'InstantLesson', foreign_key: :group_id, dependent: :destroy

    accepts_nested_attributes_for :scheduled_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
    accepts_nested_attributes_for :offline_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }

    # 返回所有版本的图片地址
    def publicizes_url
      %w(app_info list info).map {|v| [v, publicize_url(v)] }.to_h
    end

    # 当前价格
    def current_price
      price.to_f.round(2)
    end

    def order_params
      { total_amount: current_price, amount: current_price, product: self }
    end

    # 订单验证
    def validate_order(order)
      user = order.user
      order.errors[:product] << '课程目前不对外招生' unless for_sell?
      order.errors[:product] << '课程只对学生销售' unless user.student?
      order.errors[:product] << '您已经购买过该课程' if buy_tickets.where(student_id: user.id).exists?
    end

    # 发货
    def deliver(order)
      grant(order)
    end

    def for_sell?
      published? || teaching?
    end

    # 未结束课程数量
    def unclosed_lessons_count
      events_count - closed_events_count
    end

    def lessons_count
      events_count
    end

    # 当前直播课程
    def current_event
      @current_event ||= scheduled_lessons.last
    end

    private

    def buy_items
      events.where(live_end_at: nil)
    end
  end
end
