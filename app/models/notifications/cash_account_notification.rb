class CashAccountNotification < ::Notification
  REFUND_SUCCESS = :refund_success # 提现到账
  REFUND_FAIL = :refund_fail # 提现失败

  # 通知内容
  def notice_content
    I18n.t("view.notification.#{action_name}", transaction_no: notificationable.transaction_no)
  end

  def link
    "#{Payment::CashAccount.model_name.i18n_key}:#{receiver_id}"
  end
end
