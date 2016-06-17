module LiveStudio
  class Course < ActiveRecord::Base
    enum state: {
           init: 0, # 初始化
           preview: 1, # 招生中
           teaching: 2, # 已开课
           completed: 3 # 已结束
         }

    belongs_to :teacher, class_name: '::Teacher'
    belongs_to :workstation

    has_many :tickets # 听课证
    has_many :buy_tickets # 普通听课证
    has_many :taste_tickets # 试听证

    has_many :students, through: :buy_tickets

    has_many :channels
    has_many :streams, through: :channel

    # teacher's name. return blank when teacher is missiong
    def teacher_name
      teacher.try(:name)
    end

    def order_params
      { total_money: price, product: self }
    end

    def init_channel
      return unless channels.blank?
      channels.create(name: "#{name} - 直播室 - #{id}", course_id: id)
    end

    # 发货
    def deliver(order)
      ticket = buy_tickets.find_or_create_by(student_id: order.user_id)
      ticket.active!
    end

    def for_sell?
      preview? || teaching?
    end

    # 是否可购买
    def can_buy?(user)
      return false if !for_sell? || !user.student?
      user.live_studio_tickets.map(&:course_id).include?(id)
    end

    private

    after_create :init_channel_job
    def init_channel_job
      ChannelCreateJob.perform_later(id)
    end
  end
end
