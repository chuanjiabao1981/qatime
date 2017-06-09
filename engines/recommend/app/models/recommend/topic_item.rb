module Recommend
  class TopicItem < Item
    # Recommend::Position.find_or_create_by(name: '板块专题', klass_name: 'Recommend::TopicItem', kee: 'index_topic_item', status: 1)

    validates_presence_of :name, :title, :link
    validates :index, presence: true, numericality: { only_integer: true }
    validates_uniqueness_of :index, scope: [:position_id, :city_id, :deleted_at], message: I18n.t('view.recommend/position.banner_item_uniq_valid')
  end
end