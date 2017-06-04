module V1
  # 辅导班接口
  module Payment
    class Recharges < V1::Base
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

            desc '充值记录' do
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
            get 'recharges' do
              recharges = @user.payment_recharges
              recharges = query_by_date(recharges).order(created_at: :desc).paginate(page: params[:page])
              present recharges, with: Entities::Payment::Recharge
            end

            desc '充值下单' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :amount, type: Float, desc: '充值金额'
              requires :pay_type, type: String, values: ::Payment::Recharge.pay_type.values, desc: '支付方式'
            end
            post 'recharges' do
              recharge = @user.payment_recharges.new(amount: params[:amount], pay_type: params[:pay_type],
                                                     remote_ip: client_ip, source: :student_app)
              raise ActiveRecord::RecordInvalid, recharge unless recharge.save
              present recharge, with: Entities::Payment::Recharge
            end
          end
        end

        desc '充值验证' do
          headers 'Remember-Token' => {
            description: 'RememberToken',
            required: true
          }
        end
        params do
          requires :transaction_id, type: String, desc: '订单编号'
          requires :receipt_data, type: String, desc: '支付票据'
        end
        post 'recharges/:transaction_id/verify_receipt' do
          recharge = ::Payment::ItunesOrder.check_recharges(current_user, params[:receipt_data], params[:transaction_id])
          present recharge, with: Entities::Payment::Recharge
        end
      end
    end
  end
end
