module LiveStudio
  class PlayRecord < ActiveRecord::Base
    TP_STUDENT = 'student'.freeze
    TP_TEACHER = 'teacher'.freeze
    TP_MANAGER = 'manager'.freeze

    has_soft_delete

    enum play_type: %w(live replay)
    belongs_to :user
    belongs_to :course
    belongs_to :lesson
    belongs_to :ticket

    scope :of, ->(tp) { where(tp: tp) }
    scope :today, -> {where('created_at > ? and created_at <= ?', Date.today.beginning_of_day, Date.today.end_of_day)}

    def self.init_play(user, course, lesson, play_type='live')
      replay.today.find_or_create_by(user: user, course: course, lesson: lesson, play_type: play_type)
    end
  end
end
