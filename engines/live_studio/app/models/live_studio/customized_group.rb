module LiveStudio
  class CustomizedGroup < Group
    has_many :scheduled_lessons, -> { order('start_at asc, id asc') }, class_name: 'ScheduledLesson', foreign_key: :group_id, dependent: :destroy
    has_many :offline_lessons, -> { order('start_at asc, id asc') }, class_name: 'OfflineLesson', foreign_key: :group_id, dependent: :destroy
    has_many :instant_lessons, class_name: 'InstantLesson', foreign_key: :group_id, dependent: :destroy

    accepts_nested_attributes_for :scheduled_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }
    accepts_nested_attributes_for :offline_lessons, allow_destroy: true, reject_if: proc { |attributes| attributes['_update'] == '0' }

    validate :lessons_presence

    def lessons_presence
      errors.add(:events, I18n.t('view.live_studio/course.validates.lessons')) if scheduled_lessons.blank? && offline_lessons.blank?
    end

    # 返回所有版本的图片地址
    def publicizes_url
      %w(app_info list info).map {|v| [v, publicize_url(v)] }.to_h
    end

    # 当前价格
    def current_price
      return 0 if events_count <= closed_events_count
      return price.to_i if closed_events_count.zero?
      (lesson_price * (events_count - closed_events_count)).round.to_i
    end

    def lesson_price
      price.to_f / events_count
    end

    def order_params
      { total_amount: current_price, amount: current_price, product: self }
    end

    # 订单验证
    def validate_order(order)
      user = order.user
      order.errors[:product] << '课程目前不对外招生' unless for_sell?
      order.errors[:product] << '已经达到报名人数限制' if sell_out?
      order.errors[:product] << '课程只对学生销售' unless user.student?
      order.errors[:product] << '您已经购买过该课程' if buy_tickets.where(student_id: user.id).exists?
    end

    # 发货
    def deliver(order)
      grant(order)
      # 购买人数限制
      return if users_count < max_users
      self.for_sell = false
      save!
      asyn_send_homeworks_to(order.user_id)
    end

    # 补发作业
    def send_homeworks_to(user_id)
      student = ::Student.find(user_id)
      homeworks.each do |homework|
        homework.dispatch_to(student)
      end
    end

    # 异步补发作业
    def asyn_send_homeworks_to(user_id)
      LiveStudio::HomeworkSenderJob.perform_later(id, user_id)
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
      return @current_event if @current_event.present?
      @current_event ||= scheduled_lessons.find {|l| l.class_date.try(:today?) && l.unclosed? }
      @current_event ||= scheduled_lessons.select {|l| l.class_date.try(:today?) }.last
      @current_event ||= scheduled_lessons.find {|l| l.class_date > Date.today && l.unclosed? }
      @current_event ||= scheduled_lessons.select {|l| l.class_date.present? }.last
    end

    # 观看授权
    def play_authorize(user, _lesson)
      user.student? ? student_authorize(user) : others_authorize(user)
    end

    private

    def buy_items
      events.where(live_end_at: nil, type: ['LiveStudio::OfflineLesson', 'LiveStudio::ScheduledLesson'])
    end

    # 学生授权播放
    def student_authorize(user)
      tickets.available.find_by(student_id: user.id)
    end

    # 教师授权播放
    def others_authorize(user)
      return true if user.admin?
      return (user.id == workstation.manager_id) if user.manager?
      return user.id == teacher_id if user.teacher?
      !user.student? && workstation_id == user.workstation_id
    end
  end
end
