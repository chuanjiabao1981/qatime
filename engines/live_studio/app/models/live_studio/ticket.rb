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

    scope :useable, -> { where("status < ?", Ticket.statuses[:used]) }

    def type_name
      t_name = self.class.name.underscore.gsub(/live_studio\/(\w*)_ticket/, "\\1")
      I18n.t("live_studio/ticket.type_name.#{t_name}")
    end

    def taste?
      false
    end
  end
end
