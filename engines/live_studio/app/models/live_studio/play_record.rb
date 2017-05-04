module LiveStudio
  class PlayRecord < ActiveRecord::Base
    TP_STUDENT = 'student'.freeze
    TP_TEACHER = 'teacher'.freeze
    TP_MANAGER = 'manager'.freeze

    has_soft_delete

    enum play_type: %w(live replay)
    belongs_to :user
    belongs_to :course
    belongs_to :product, polymorphic: true
    belongs_to :lesson
    belongs_to :video_lesson, class_name: 'VideoLesson', foreign_key: :lesson_id
    belongs_to :ticket

    scope :of, ->(tp) { where(tp: tp) }
    scope :today, -> {where('created_at > ? and created_at <= ?', Date.today.beginning_of_day, Date.today.end_of_day)}

    def self.init_play(user, course, lesson, ticket = nil)
      replay.today.find_or_create_by(user: user, product: course, lesson_id: lesson.id, ticket: ticket)
    end
  end
end
