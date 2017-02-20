class PaymentOrderNotification < ::Notification

  ACTION_REFUND_SUCCESS = :refund_success # 退款成功通知
  ACTION_REFUND_FAIL = :refund_fail # 退款审核失败

  # 通知内容
  def notice_content
    I18n.t("view.notification.#{notificationable.model_name.i18n_key}.#{action_name}",
           transaction_no: notificationable.transaction_no,
    )
  end
end
