module Recommend
  class Item < ActiveRecord::Base
    has_soft_delete
    belongs_to :position
    belongs_to :target, polymorphic: true
    belongs_to :owner, polymorphic: true
    class_attribute :recomend_for
    serialize :platforms, Array
    belongs_to :city

    enum reason: %w(newest hottest)
    PLATFORMS = {
      'pc': '0',
      'android': '1',
      'ios': '2'
    }

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
end
