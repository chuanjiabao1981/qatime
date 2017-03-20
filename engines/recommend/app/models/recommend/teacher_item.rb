module Recommend
  class TeacherItem < Item
    self.recomend_for = Teacher
    validates_presence_of :target_id, :title
    validates :index, presence: true, numericality: { only_integer: true }
    validates_uniqueness_of :index, scope: [:position_id, :city_id, :target_id], message: I18n.t('view.recommend/position.teacher_item_uniq_valid')

    def logo_url
      target.avatar_url(:ex_big)
    end
  end
end
