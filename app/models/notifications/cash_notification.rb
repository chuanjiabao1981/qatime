class CashNotification < ::Notification
  ACTION_RECHARGE_SUCCESS = :recharge_success # 充值成功
  ACTION_RECHARGE_FAIL = :recharge_fail # 充值失败
  ACTION_WITHDRAW_SUCCESS = :withdraw_success # 提现成功
  ACTION_WITHDRAW_REFUSE = :withdraw_refuse # 审核拒绝
  ACTION_WITHDRAW_ALLOW = :withdraw_allow # 审核通过

  # 通知内容
  def notice_content
    I18n.t("view.notification.#{model_name.i18n_key}.#{action_name}",
           transaction_no: notificationable.transaction_no,
           amount: notificationable.amount)
  end
end
