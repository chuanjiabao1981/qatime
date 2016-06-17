module LiveStudio
  class Ticket < ActiveRecord::Base
    belongs_to :course
    belongs_to :student
    belongs_to :lesson

    enum state: {
           inactive: 0,
           active: 1,
           used: 2,
           waste: 99
         }
  end
end
