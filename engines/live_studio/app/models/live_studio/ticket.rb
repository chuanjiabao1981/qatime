module LiveStudio
  class Ticket < ActiveRecord::Base
    has_soft_delete

    belongs_to :course
    belongs_to :student
    belongs_to :lesson

    enum status: {
           inactive: 0, # 准备试听
           active: 1, # 可用
           pre_used: 2, # 已经用完最后课程没有结束
           used: 3, # 已经用完
           replaced: 97, # 试听证被正式听课证替换
           expired: 98, # 未使用过期
           waste: 99 # 不可用
         }

    scope :available, -> { where("status < ?", Ticket.statuses[:used]) }
    scope :visiable, -> { where("status <= ?", Ticket.statuses[:used]) }

    def type_name
      return I18n.t("live_studio/ticket.type_name.taste_#{status}") if taste?
      I18n.t("live_studio/ticket.type_name.buy_#{status}")
    end

    def taste?
      false
    end

    def inc_used_count!(urgent=false)
      self.used_count += 1
      if urgent && used_count >= buy_count
        self.used!
      elsif used_count >= buy_count
        self.pre_used!
      end
      save
    end
  end
end
