module Recommend
  class ReplayItem < Item
    # Recommend::Position.find_or_create_by(name: '精彩回放', klass_name: 'Recommend::ReplayItem', kee: 'index_replay_item', status: 1)
    self.recomend_for = LiveStudio::Course

    attr_accessor :course_id, :course_required, :course_type

    enumerize :course_type, in: { course: 'LiveStudio::Course', interactive_course: 'LiveStudio::InteractiveCourse' }#, group: 'LiveStudio::Group' }

    validates :course_id, :course_type, presence: true, if: :course_required
    validates_presence_of :target_id, :target_type, :target
    validates_uniqueness_of :target_id, scope: [:position_id, :city_id, :target_type, :deleted_at], message: I18n.t('view.recommend/position.replay_item_uniq_valid')

    def logo_url
      course.publicize_url(:list)
    end

    def course
      target.try(:course) #|| target.try(:group)
    end

    def video
      target.replays.where(video_for: 0).first rescue nil
    end

    def increment_replay_times
      increment(:replay_times, 1).update_column(:replay_times, self[:replay_times])
    end
  end
end