module V1
  # 提现接口
  module Payment
    class Refunds < V1::Base
      namespace "payment" do
        before do
          authenticate!
        end
        namespace :users do
          route_param :user_id do
            helpers do
              def auth_params
                @user = ::User.find(params[:user_id])
              end
            end

            desc '退款信息预览' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :order_id, type: String, desc: '订单id'
            end
            get 'refunds/info' do
              order = @user.orders.find_by!(transaction_no: params[:order_id])
              present LiveService::OrderDirector.new(order).generate_refund, with: Entities::Payment::Refund
            end

            desc '提交退款申请' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :order_id, type: String, desc: '订单id'
              requires :reason, type: String, desc: '退款原因'
            end
            post 'refunds' do
              order = @user.orders.find_by!(transaction_no: params[:order_id])
              refund = LiveService::OrderDirector.new(order).refund!
              raise ActiveRecord::RecordInvalid, refund if refund.errors.any?
              refund.create_refund_reason(reason: params[:reason])
              present refund, with: Entities::Payment::Refund
            end

            desc '退款记录' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              optional :start_date, type: String, desc: '开始日期'
              optional :end_date, type: String, desc: '结束日期'
              optional :page, type: Integer, desc: '页数'
            end
            get 'refunds' do
              refunds = @user.payment_refunds
              refunds = query_by_date(refunds).order(created_at: :desc).paginate(page: params[:page])
              present refunds, with: Entities::Payment::Refund
            end

            desc '取消退款' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :order_id, type: String, desc: '订单ID'
            end
            put 'refunds/:order_id/cancel' do
              refund = @user.payment_refunds.init.find_by(transaction_no: params[:order_id])
              refund.cancel!
              present refund, with: Entities::Payment::Refund
            end
          end
        end
      end
    end
  end
end
