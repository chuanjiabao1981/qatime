module Recommend
  class Position < ActiveRecord::Base
    has_soft_delete
    has_many :items

    enum status: %w(disable enable)

    def status_text
      I18n.t("enums.recommend.#{status}")
    end
  end
end
