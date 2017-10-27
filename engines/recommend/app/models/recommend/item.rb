module Recommend
  class Item < ActiveRecord::Base
    extend Enumerize

    has_soft_delete
    belongs_to :position
    belongs_to :target, polymorphic: true
    belongs_to :owner, polymorphic: true
    class_attribute :recomend_for
    serialize :platforms, Array
    belongs_to :city

    # 名师授课 最受欢迎 免费试听 插班优惠
    enum tag_one: { star_teacher: 1, best_seller: 2, free_tastes: 3, join_cheap: 4 }

    enumerize :tag_one, in: { star_teacher: 1, best_seller: 2, free_tastes: 3, join_cheap: 4 }

    enum reason: %w(newest hottest)
    PLATFORMS = {
      'pc' => '0',
      'android' => '1',
      'ios' => '2'
    }

    scope :by_city, ->(city_id) { where(city_id: city_id) }
    scope :top, -> { where(top: true) }

    def self.default
      Position.by_klass_name(self.model_name.to_s).try(:first)
    end

    def reason_text
      reason.blank? ? '无' : I18n.t("enums.recommend.reason.#{reason}")
    end

    def self.i18n_options_reasons
      reasons.map{|k,_| [I18n.t("enums.recommend.reason.#{k}"), k]}
    end

    # 排序占位
    def placehold!
      return if index.nil?
      self.class.placehold!(position, city_id, index)
    end

    def save(options)
      Recommend::Item.transaction do
        placehold! if options.delete(:placehold)
        super(options)
      end
    end

    # 占位
    def self.placehold!(position, city_id, target = 1)
      current_index = target.to_i
      modify_items = []
      position.items.by_city(city_id).where("index >= ?", current_index).order(:index).each do |item|
        p "=====>>> #{current_index} : #{item.index}"

        break if item.index > current_index
        item.index += 1
        current_index = item.index
        modify_items << item
      end
      modify_items.reverse.map(&:save!)
    end
  end

  require_relative './teacher_item'
  require_relative './live_studio_course_item'
  require_relative './banner_item'
  require_relative './choiceness_item'
end
