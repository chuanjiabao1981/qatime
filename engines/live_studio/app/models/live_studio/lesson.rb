module LiveStudio
  class Lesson < ActiveRecord::Base
    enum state: {
      init: 0, # 初始化
      ready: 1, # 等待上课
      teaching: 2, # 上课中
      finished: 3, # 已完成
      completed: 4 # 已结算
    }

    belongs_to :course
    belongs_to :teacher, class_name: ::Teacher # 区别于course的teacher防止课程中途换教师

    validates :name, :description, :course_id, :start_time, :end_time, :class_date, presence: true

    # 课程完成
    # 课程完成以后进行结算
    def finish
      self.teacher = course.teacher
      # TODO 需要改成付费听课人数
      self.live_count = live_count # 听课人数
      self.real_time = ((live_end_at - live_start_at) / 60.0).ceil # 实际直播时间
      finished!
      complete!
    end

    # 完成结算
    # 结算失败的课程可以重复结算
    def complete!
      return if finished?
      # 本次课程学费
      # 根据学生单次课程成本价计算
      money = course.buy_tickets.sum(&:lesson_price)
      CashAccount.transaction do
        money -= system_fee!(money) # 系统收取佣金
        money -= teacher_fee!(money) # 教师分成
        manager_fee!(money) # 代理商分成
        completed!
      end
    end

    def has_finished?
      self[:state] > Lesson.states[:ready]
    end

    # 是否可以准备上课
    def ready_for?
      init? && class_date == Date.today
    end

    private

    # 系统服务费
    def system_fee!(money)
      system_money = Course::SYSTEM_FEE * live_count * real_time
      system_money = money if system_money > money
      system_money
    end

    # 教师分成
    def teacher_fee!(money)
      teacher_money = money * course.teacher_percentage
      teacher.cash_account.add(teacher_money, self, "课程完成 - #{name}")
      teacher_money
    end

    # 代理商分成
    def manager_fee!(money)
      course.manager.cash_account.add(money, self, "课程完成 - #{name}")
    end

  end
end
