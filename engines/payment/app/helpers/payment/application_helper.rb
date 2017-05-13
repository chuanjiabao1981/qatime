module Payment
  module ApplicationHelper
    EARNING_RECORDS_CATEGORIES = %w(total daily three_day weekly monthly quarterly half_yearly yearly).freeze

    def earning_records_category_options
      EARNING_RECORDS_CATEGORIES.map {|cate| [t("view.payment/earning_records.search.category.#{cate}"), cate] }
    end

    # 支付方式
    def pay_type_options(transaction_type, source)
      GlobalSettings.payment.send("#{transaction_type}_pay_types").send(source).map { |pay_type| [t("view.pay_types.#{pay_type}"), pay_type] }
    end

    # 提现方式
    def withdraw_type_options(transaction_type, source)
      GlobalSettings.payment.send("#{transaction_type}_pay_types").send(source).map { |pay_type| [t("view.withdraw_types.#{pay_type}"), pay_type] }
    end
  end
end
