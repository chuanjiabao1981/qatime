module LiveStudio
  class PlayRecord < ActiveRecord::Base
    belongs_to :user
    belongs_to :course
    belongs_to :lesson
  end
end
