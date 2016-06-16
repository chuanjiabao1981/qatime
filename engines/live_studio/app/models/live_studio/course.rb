module LiveStudio
  class Course < ActiveRecord::Base
    belongs_to :teacher
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
  end
end
