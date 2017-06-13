module Recommend
  class ReplayItem < Item
    # Recommend::Position.find_or_create_by(name: '精彩回放', klass_name: 'Recommend::ReplayItem', kee: 'index_replay_item', status: 1)
    self.recomend_for = LiveStudio::Course

    attr_accessor :course_id, :course_required
    validates :course_id, presence: true, if: :course_required
    validates_presence_of :target_id, :target_type, :target
    validates_uniqueness_of :target_id, scope: [:position_id, :city_id, :target_type, :deleted_at], message: I18n.t('view.recommend/position.replay_item_uniq_valid')

    def logo_url
      target.course.publicize_url(:list)
    end

    def course
      target.try(:course) || ::LiveStudio::Course.find_by(id: course_id)
    end

    def video
      target.replays.where(video_for: 0).first rescue nil
    end
  end
end