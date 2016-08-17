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
            order = ::Payment::Order.find_by(order_no: params[:id])
            order.status
          end
        end
      end
    end
  end
end
