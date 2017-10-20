module Payment
  class AlipayOrder < RemoteOrder
    def payment_url(_size = nil)
      AlipayOrder.client.page_execute_url(
        method: 'alipay.trade.page.pay',
        return_url: order.return_url,
        notify_url: order.notify_url,
        biz_content: {
          out_trade_no: order_no,
          product_code: 'FAST_INSTANT_TRADE_PAY',
          total_amount: amount.to_f.to_s,
          subject: order.subject
        }.to_json
      )
    end

    def proccess_notify(notify_params)
      return unless unpaid?
      check_notify(notify_params)
      lock!
      self.notify_id = notify_params[:notify_id]
      self.trade_no = notify_params[:trade_no]
      self.notify_time = notify_params[:notify_time]
      save!
      %w(TRADE_SUCCESS TRADE_FINISHED).include?(notify_params[:trade_status]) ? pay! : fail!
    end

    def proccess_result(result_params)
      return if !unpaid? || result_params[:is_success] != "T"
      check_notify(result_params)
      lock!
      self.notify_id = result_params[:notify_id]
      self.trade_no = result_params[:trade_no]
      self.notify_time = result_params[:notify_time]
      pay
      save!
    end

    def app_pay_str
      AlipayOrder.client.sdk_execute(
        method: 'alipay.trade.app.pay',
        notify_url: order.notify_url,
        biz_content: {
          out_trade_no: order_no,
          product_code: 'FAST_INSTANT_TRADE_PAY',
          total_amount: amount.to_f.to_s,
          subject: order.subject
        }.to_json
      )
    end

    def self.client
      @client ||= Alipay::Client.new(url: ENV['ALIPAY_API'],  app_id: ENV['APP_ID'], app_private_key: ENV['APP_PRIVATE_KEY'], alipay_public_key: ENV['ALIPAY_PUBLIC_KEY'])
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
      raise Payment::InvalidNotify, '无效通知' unless AlipayOrder.client.verify?(notify_params)
      raise Payment::IncorrectAmount, '金额不正确' unless notify_params[:total_fee].to_f == amount.to_f
    end
  end
end
