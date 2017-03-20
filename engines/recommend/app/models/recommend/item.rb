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

    # 名师授课 最受欢迎
    enum tag_one: { star_teacher: 1, best_seller: 2 }
    # 免费试听 插班优惠
    enum tag_two: { free_tastes: 1, join_cheap: 2 }

    enumerize :tag_one, in: { star_teacher: 1, best_seller: 2 }
    enumerize :tag_two, in: { free_tastes: 1, join_cheap: 2 }

    enum reason: %w(newest hottest)
    PLATFORMS = {
      'pc' => '0',
      'android' => '1',
      'ios' => '2'
    }

    def self.default
      Position.by_klass_name(self.model_name.to_s).try(:first)
    end

    def reason_text
      reason.blank? ? '无' : I18n.t("enums.recommend.reason.#{reason}")
    end

    def self.i18n_options_reasons
      reasons.map{|k,_| [I18n.t("enums.recommend.reason.#{k}"), k]}
    end
  end

  require_relative './teacher_item'
  require_relative './live_studio_course_item'
  require_relative './banner_item'
  require_relative './choiceness_item'
end
