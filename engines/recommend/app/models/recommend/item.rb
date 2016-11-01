module Recommend
  class Item < ActiveRecord::Base
    has_soft_delete
    belongs_to :position
    belongs_to :target, polymorphic: true
    belongs_to :owner, polymorphic: true
    mount_uploader :logo, ::PublicizeUploader
    class_attribute :recomend_for

    enum reason: %w(fast hot)

    def reason_text
      reason.blank? ? '无' : I18n.t("enums.recommend.reason.#{reason}")
    end

    def self.i18n_options_reasons
      reasons.map{|k,_| [I18n.t("enums.recommend.reason.#{k}"), k]}
    end
  end
  require_relative './teacher_item'
  require_relative './live_studio_course_item'
end
