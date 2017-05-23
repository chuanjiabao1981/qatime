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

            desc '收益记录' do
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
            get 'earning_records' do
              earning_records = @user.cash_account!.earning_records.includes(:target)
              earning_records = query_by_date(earning_records).order(created_at: :desc).paginate(page: params[:page])
              present earning_records, with: Entities::Payment::EarningRecord
            end
          end
        end
      end
    end
  end
end
