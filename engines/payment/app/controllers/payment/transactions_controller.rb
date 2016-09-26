require_dependency "payment/application_controller"

module Payment
  class TransactionsController < ApplicationController
    layout 'payment'

    skip_before_action :verify_authenticity_token, only: :notify

    before_action :set_transaction

    def show
    end

    def notify
      proccess_result
      render '' && return unless @transaction.remote_order.paid?
      if @transaction.pay_type.weixin?
        render xml: { return_code: "SUCCESS" }.to_xml(root: 'xml', dasherize: false)
      elsif @transaction.pay_type.alipay?
        render text: 'success'
      end
    end

    def result
      proccess_result if params[:notify_type] == "trade_status_sync"
      unless request.xhr?
        if @transaction.is_a? Payment::Recharge
          redirect_to payment.cash_user_path(@transaction.user) && return
        else
          redirect_to live_studio.student_courses_path(@transaction.user) && return
        end
      end
    end

    private

    def set_transaction
      @transaction ||= Transaction.find_by!(transaction_no: params[:id])
    end

    def current_resource
      @current_resource ||= set_transaction.user
    end

    def proccess_result
      return false unless @transaction.remote_order
      notify_params = if @transaction.pay_type.alipay?
                        alipay_params
                      elsif @transaction.pay_type.weixin?
                        weixin_params
                      end
      @transaction.remote_order.proccess_notify(notify_params) if notify_params.present?
    end

    def weixin_params
      Hash.from_xml(request.body.read)["xml"]
    end

    def alipay_params
      params.except(*request.path_parameters.keys)
    end
  end
end
