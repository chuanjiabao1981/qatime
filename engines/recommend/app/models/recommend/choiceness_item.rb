module Recommend
  class ChoicenessItem < Item
    self.recomend_for = LiveStudio::Course
    validates_presence_of :target_id, :title
    validates :index, presence: true, numericality: { only_integer: true }
    validates_uniqueness_of :index, scope: [:position_id, :city_id, :target_id, :deleted_at], message: I18n.t('view.recommend/position.choiceness_item_uniq_valid')

    def logo_url
      target.publicize_url(:list)
    end
  end
end
