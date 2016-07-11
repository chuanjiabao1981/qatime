module LiveStudio
  class PlayRecord < ActiveRecord::Base
    TP_STUDENT = 'student'.freeze
    TP_TEACHER = 'teacher'.freeze
    TP_MANAGER = 'manager'.freeze

    has_soft_delete

    belongs_to :user
    belongs_to :course
    belongs_to :lesson
    belongs_to :ticket

    scope :of, ->(tp) { where(tp: tp) }
  end
end
