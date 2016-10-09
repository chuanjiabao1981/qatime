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
        end
      end
    end
  end
end
