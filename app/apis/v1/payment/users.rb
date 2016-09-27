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
          end
        end
      end
    end
  end
end
