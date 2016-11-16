module LiveStudio
  # 招生申请
  class CourseRequest < ActiveRecord::Base
    belongs_to :user
    belongs_to :course
    belongs_to :workstation

    scope :handled, -> { where(status: [1, 2]) }

    include AASM

    enum status: {
      submitted: 0, # 已提交
      accepted: 1, # 审核通过
      rejected: 2 # 已拒绝
    }

    aasm column: :status, enum: true do
      state :submitted, initial: true
      state :accepted
      state :rejected

      event :accept, after: :publish_course do
        transitions from: :submitted, to: :accepted
      end

      event :reject do
        transitions from: :submitted, to: :rejected
      end
    end

    def publish_course
      return unless course.init?
      course.preview!
      LiveService::CourseDirector.new(course).instance_for_course
    end
  end
end
