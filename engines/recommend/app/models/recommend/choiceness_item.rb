module Recommend
  class ChoicenessItem < Item
    self.recomend_for = LiveStudio::Course

    enumerize :target_type, in: { course: 'LiveStudio::Course', interactive_course: 'LiveStudio::InteractiveCourse', video_course: 'LiveStudio::VideoCourse' }

    validates_presence_of :target_id, :target_type, :target, :title
    validates :index, presence: true, numericality: { only_integer: true }
    validates_uniqueness_of :index, scope: [:position_id, :city_id, :deleted_at], message: I18n.t('view.recommend/position.choiceness_item_uniq_valid')

    def logo_url
      target.publicize_url(:list)
    end
  end
end
