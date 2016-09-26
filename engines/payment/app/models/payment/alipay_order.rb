module Payment
  class AlipayOrder < RemoteOrder
    def payment_url(_size = nil)
      pay_url
    end

    def proccess_notify(notify_params)
      return unless unpaid?
      check_notify(notify_params)
      lock!
      self.notify_id = notify_params[:notify_id]
      self.trade_no = notify_params[:trade_no]
      self.notify_time = notify_params[:notify_time]
      save!
      notify_params[:is_success] ? pay! : fail!
    end

    private

    after_create :remote_sync
    def remote_sync
      return if Rails.env.test? || order.created_at < 3.hours.ago
      lock!
      self.pay_url = Alipay::Service.create_direct_pay_by_user_url(remote_params)
      save!
    end

    def remote_params
      {
        out_trade_no: order_no,
        subject: order.subject,
        total_fee: amount.to_f,
        return_url: order.return_url,
        notify_url: order.notify_url
      }
    end

    def check_notify(notify_params)
      raise Payment::InvalidNotify, '无效通知' unless Alipay::Notify.verify?(notify_params)
      raise Payment::IncorrectAmount, '金额不正确' unless notify_params[:total_fee].to_f == amount.to_f
      raise Payment::InvalidNotify, '无效通知' unless notify_params[:seller_id] == Alipay.pid.to_s
    end
  end
end
