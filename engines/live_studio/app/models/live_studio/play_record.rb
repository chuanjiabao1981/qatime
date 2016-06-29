module LiveStudio
  class PlayRecord < ActiveRecord::Base
    has_soft_delete

    belongs_to :user
    belongs_to :course
    belongs_to :lesson
    belongs_to :ticket
  end
end
