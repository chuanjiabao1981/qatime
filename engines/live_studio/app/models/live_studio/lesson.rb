module LiveStudio
  class Lesson < ActiveRecord::Base
    belongs_to :course

    validates :name, :description, :course_id, :start_time, :end_time, :class_date, presence: true
  end
end
