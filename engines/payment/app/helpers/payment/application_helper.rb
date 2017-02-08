module Payment
  module ApplicationHelper
    EARNING_RECORDS_CATEGORIES = %w(total daily three_day weekly monthly quarterly half_yearly yearly).freeze

    def earning_records_category_options
      EARNING_RECORDS_CATEGORIES.map {|cate| [t("view.payment/earning_records.search.category.#{cate}"), cate] }
    end
  end
end
