module LiveStudio
  class Ticket < ActiveRecord::Base
    has_soft_delete
    serialize :got_lesson_ids, Array

    default_scope { order('id DESC') }

    belongs_to :course
    belongs_to :student, class_name: "::Student"
    belongs_to :lesson

    has_many :ticket_items

    enum status: {
      inactive: 0,   # 准备试听
      active: 1,     # 可用
      pre_used: 2,   # 已经用完最后课程没有结束
      used: 3,       # 已经用完
      refunding: 95, # 退款中
      refunded: 96,  # 已退款,不可用
      replaced: 97,  # 试听证被正式听课证替换
      expired: 98,   # 未使用过期
      waste: 99      # 不可用
    }

    # 可用
    scope :available, -> { where("live_studio_tickets.status < ?", statuses[:used]) }
    # 不可用
    scope :unavailable, -> { where("live_studio_tickets.status >= ?", statuses[:used]) }
    scope :visiable, -> { where("live_studio_tickets.status <= ?", statuses[:used]) }
    scope :authorizable, -> { where("live_studio_tickets.status < ?", statuses[:pre_used]) }

    def type_name
      return I18n.t("live_studio/ticket.type_name.taste_#{status}") if taste?
      I18n.t("live_studio/ticket.type_name.buy_#{status}")
    end

    def taste?
      false
    end

    # 记录观看
    def record_play(attrs)
      Ticket.transaction do
        PlayRecord.create!(attrs)
        inc_used_count!
      end
    end

    # 增加使用次数
    def inc_used_count!(_urgent = false)
      lock!
      self.used_count += 1
      used! if used_count >= buy_count
      save!
    end

    # 是否可用
    def available?
      self[:status] < Ticket.statuses[:used]
    end

    # 是否可以授权新的课程
    def authorizable?
      self[:status] < Ticket.statuses[:pre_used]
    end

    private

    after_create :add_to_team
    def add_to_team
      ::Chat::TeamMemberCreatorJob.perform_later(course.id, student_id)
    end

    after_create :instance_items
    def instance_items
      ticket_items.create(course.lessons.unclosed.map { |l| { lesson_id: l.id } })
    end
  end
end
