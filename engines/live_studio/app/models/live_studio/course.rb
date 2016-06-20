module LiveStudio
  class Course < ActiveRecord::Base
    enum status: {
      init: 0, # 初始化
      preview: 1, # 招生中
      teaching: 2, # 已开课
      completed: 3 # 已结束
    }

    validates :name, presence: true

    validates :workstation, :teacher, presence: true

    belongs_to :teacher, class_name: '::Teacher'
    belongs_to :workstation

    has_many :tickets # 听课证
    has_many :buy_tickets # 普通听课证
    has_many :taste_tickets # 试听证
    has_many :lessons # 课时

    has_many :students, through: :buy_tickets

    has_many :channels
    has_many :streams, through: :channel

    scope :for_sell, -> { where(status: [Course.statuses[:preview], Course.statuses[:teaching]]) }

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
      # 好奇怪的语法
      # 由于User没有设置单表集成, user无法自动生成合适类型
      # 可能会造成 n + 1查询
      !::Student.find(user.id).live_studio_tickets.map(&:course_id).include?(id)
      # !user.live_studio_tickets.map(&:course_id).include?(id)
    end

    def short_description(len=20)
      description.truncate(len)
    end

    def validate_order(order)
      user = order.user
      order.errors[:product] << '课程目前不对外招生' unless for_sell?
      order.errors[:product] << '课程只对学生销售' unless user.student?
      order.errors[:product] << '您已经购买过该课程' if user.live_studio_tickets.map(&:course_id).include?(id)
    end

    private

    after_create :init_channel_job
    def init_channel_job
      ChannelCreateJob.perform_later(id)
    end
  end
end
