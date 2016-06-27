module LiveStudio
  class Course < ActiveRecord::Base
    SYSTEM_FEE = 0.1 # 系统每个人每分钟收费

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
    has_many :push_streams, through: :channels
    has_many :pull_streams, through: :channels

    has_many :play_records #听课记录

    # TODO 换成真正的地址
    def push_stream
      push_streams.last
    end

    scope :for_sell, -> { where(status: [Course.statuses[:preview], Course.statuses[:teaching]]) }

    # teacher's name. return blank when teacher is missiong
    def teacher_name
      teacher.try(:name)
    end

    def order_params
      { total_money: price, product: self }
    end

    def status_text
      I18n.t("status.#{status}")
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

    # 用户是否已经购买
    def own_by?(user)
      user.live_studio_tickets.map(&:course_id).include?(id)
    end

    # 是否卖给用户
    def sell_to?(user)
      return false unless user.student? # 辅导班只卖给学生
      return false unless for_sell? # 必须在售中的辅导班
      !own_by?(user) # 没买过该辅导班才可以购买
    end

    def short_description(len=20)
      description.try(:truncate, len)
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
      init_channel
      # ChannelCreateJob.perform_later(id)
    end
  end
end
