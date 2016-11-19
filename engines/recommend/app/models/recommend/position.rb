module Recommend
  class Position < ActiveRecord::Base
    has_soft_delete
    has_many :items

    enum status: %w(disable enable)
    enum platforms: %w(pc android ios)


    def status_text
      I18n.t("enums.recommend.status.#{status}")
    end
  end
end
