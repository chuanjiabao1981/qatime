module V1
  # 辅导班接口
  module Payment
    class Users < V1::Base
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

            desc '资金概况' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              optional :t, type: String, desc: '时间戳'
            end
            get 'cash' do
              cash_account = @user.cash_account!
              present cash_account, with: Entities::Payment::CashAccount
            end

            desc '消费记录' do
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
            get 'consumption_records' do
              consumption_records = @user.cash_account!.consumption_records.includes(:target)
              consumption_records = query_by_date(consumption_records).order(created_at: :desc).paginate(page: params[:page])
              present consumption_records, with: Entities::Payment::ConsumptionRecord
            end

            desc '设置支付密码' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :ticket_token, type: String, desc: '验证token'
              requires :pament_password, type: String, desc: '支付密码'
            end
            post 'payment_password' do
              cash_account = @user.cash_account!
              raise ActiveRecord::RecordInvalid, cash_account unless cash_account.update_with_token(:set_password, ticket_token: params[:ticket_token], password: params[:pament_password])
              'ok'
            end

            desc '修改支付密码' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              optional :ticket_token, type: String, desc: '验证token'
              optional :current_pament_password, type: String, desc: '当前支付密码'
              requires :pament_password, type: String, desc: '支付密码'
              exactly_one_of :ticket_token, :current_pament_password
            end
            put 'payment_password' do
              cash_account = @user.cash_account!
              raise APIErrors::PaymentPasswordBlank, "没有设置支付密码" unless cash_account.password?
              result =
                if params[:current_pament_password].present?
                  cash_account.update_with_password(current_password: params[:current_pament_password], password: params[:pament_password])
                else
                  cash_account.update_with_token(:update_password, ticket_token: params[:ticket_token], password: params[:pament_password])
                end
              raise ActiveRecord::RecordInvalid, cash_account unless result
              'ok'
            end
          end
        end
      end
    end
  end
end
