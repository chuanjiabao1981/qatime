module ActiveRecordExtend
  extend ActiveSupport::Concern

  included do
    # ..
  end

  module ClassMethods
  end

  # {:coupon_code=>["无效!"]}
  # return "优惠码无效"
  def error_msgs
    msgs = []
    errors.messages.each do |k, v|
      label = I18n.t("error_msgs.labels.defaults.#{k}")
      label = I18n.t("error_msgs.labels.#{self.class.model_name.i18n_key}.#{k}") if label.include?("translation missing")
      label = "" if label.include?("translation missing")
      msgs << "#{label}#{v.join('')}"
    end
    msgs.join(' ')
  end

end
