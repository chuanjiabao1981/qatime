# 课程介绍
class CourseIntro < ActiveRecord::Base
  include AASM
  extend Enumerize

  # stopping: 未使用 running: 已使用
  enum status: { stopping: 0, running: 1 }
  enumerize :status, in: { stopping: 0, running: 1 }

  aasm column: :status, enum: true do
    state :stopping, initial: true
    state :running

    event :run do
      transitions from: :stopping, to: :running
    end

    event :stop do
      transitions from: :running, to: :stopping
    end
  end

  belongs_to :video

  validates :video_id, presence: true
  validates :title, presence: true, length: { maximum: 30 }

  def self.top
    running.first
  end
end
