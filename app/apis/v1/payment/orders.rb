module V1
  # 辅导班接口
  module Payment
    class Orders < V1::Base
      namespace "payment" do
        resource :orders do
          before do
            authenticate!
          end

          desc '支付结果查询' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: String, desc: '订单ID'
          end
          get ':id/result' do
            order = ::Payment::Transaction.find_by!(transaction_no: params[:id])
            order.status
          end

          desc '订单列表' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end

          params do
            optional :page, type: Integer, desc: '当前页面'
            optional :per_page, type: Integer, desc: '每页记录数'
            optional :cate, type: String, values: %w(unpaid paid canceled), desc: '过滤条件 unpaid:未付款; paid: 已付款; canceled: 取消订单;'
          end

          get do
            orders = LiveService::OrderDirector.orders_for_user_index(current_user, params).order(id: :desc).paginate(page: params[:page], per_page: params[:per_page])
            present orders, with: Entities::Payment::Order, type: :product
          end

          desc '取消订单' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end

          params do
            requires :id, type: String, desc: '订单ID'
          end

          put ':id/cancel' do
            order = ::Payment::Order.find_by(transaction_no: params[:id])
            if order.canceled!
              present order, with: Entities::Payment::Order, type: :product
            else
              raise(ActiveRecord::RecordInvalid.new(order))
            end
          end

          # 获取订单支付的token
          desc '订单支付ticket_token' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: String, desc: '订单ID'
            requires :password, type: String, desc: '支付密码'
          end
          post ':id/pay/ticket_token' do
            order = ::Payment::Order.find_by!(user_id: current_user.id, transaction_no: params[:id])
            cash_account = current_user.cash_account!
            raise APIErrors::PaymentPasswordBlank, "支付密码未设置" unless cash_account.password?
            raise APIErrors::PasswordInvalid, "密码验证失败" unless cash_account.authenticate(params[:password])
            ::TicketToken.instance_token(order, :pay)
          end

          # 确认支付订单
          desc '订单支付' do
            headers 'Remember-Token' => {
              description: 'RememberToken',
              required: true
            }
          end
          params do
            requires :id, type: String, desc: '订单ID'
            requires :ticket_token, type: String, desc: '验证token'
          end
          post ':id/pay' do
            order = ::Payment::Order.find_by!(user_id: current_user.id, transaction_no: params[:id])
            begin
              order.pay_with_ticket_token!(params[:ticket_token]) if order.account?
            rescue ::Payment::BalanceNotEnough
              raise APIErrors::BalanceNotEnough, "余额不足"
            rescue ::Payment::TokenInvalid
              raise APIErrors::TokenInvalid, "授权Token无效"
            end
            present order, with: Entities::Payment::Order
          end
        end
      end
    end
  end
end
