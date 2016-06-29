module LiveStudio
  class Ticket < ActiveRecord::Base
    belongs_to :course
    belongs_to :student
    belongs_to :lesson

    enum status: {
           inactive: 0,
           active: 1,
           used: 2,
           replaced: 97,
           expired: 98,
           waste: 99
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

    def inc_used_count!
      self.used_count += 1
      self.used! if used_count >= buy_count
      save
    end
  end
end
