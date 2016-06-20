module LiveStudio
  class Lesson < ActiveRecord::Base
    belongs_to :course
  end
end
