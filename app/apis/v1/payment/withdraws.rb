module V1
  # 提现接口
  module Payment
    class Withdraws < V1::Base
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

            desc '提现信息' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              optional :t, type: String, desc: '时间戳 可不传'
            end
            get 'withdraws/info' do
              wechat_users = current_user.wechat_users.platform_of(:app)
              cash_account = current_user.cash_account!
              present wechat_users, root: :wechat_users, with: Entities::Qawechat::WechatUser
              present cash_account, root: :cash, with: Entities::Payment::CashAccount
            end

            desc '提现token' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :password, type: String, desc: '支付密码'
            end
            get 'withdraws/ticket_token' do
              UserService::CashAccountManager.new(@user).check_password(params[:password])
              ::TicketToken.instance_token(@user.cash_account!, :withdraw)
            end

            desc '提交提现申请' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :amount, type: Float, desc: '提现金额'
              requires :pay_type, type: String, desc: '提现方式', values: %w(bank alipay weixin)
              requires :account, type: String, desc: '账号'
              requires :name, type: String, desc: '姓名'
              requires :ticket_token, type: String, desc: '验证token'
              optional :access_code, type: String, desc: '微信授权code'
              optional :openid, type: String, desc: '微信授权openid'
            end
            post 'withdraws' do
              wechat_user =
                if params[:access_code].present?
                  UserService::WechatApi.new(params[:access_code], 'app').web_access_token
                elsif params[:openid].present?
                  ::Qawechat::WechatUser.find_by(openid: params[:openid])
                end

              raise(APIErrors::WithdrawExisted) if @user.payment_withdraws.init.present?
              UserService::CashAccountManager.new(@user).check_token(:withdraw, params[:ticket_token])
              withdraw_params = { amount: params[:amount], pay_type: params[:pay_type], status: :init }
              withdraw = @user.payment_withdraws.new(withdraw_params)
              raise ActiveRecord::RecordInvalid, withdraw unless withdraw.save
              if withdraw.weixin? # 微信提现使用openid
                withdraw.create_withdraw_record(account: wechat_user.openid, name: wechat_user.nickname)
              else
                withdraw.create_withdraw_record(account: params[:account], name: params[:name])
              end
              present withdraw, with: Entities::Payment::Withdraw
            end

            desc '提现记录' do
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
            get 'withdraws' do
              withdraws = @user.payment_withdraws
              withdraws = query_by_date(withdraws).order(created_at: :desc).paginate(page: params[:page])
              present withdraws, with: Entities::Payment::Withdraw
            end

            desc '提现取消' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :id, type: Integer, desc: '订单号'
            end
            put 'withdraws/:id/cancel' do
              withdraw = @user.payment_withdraws.find_by(transaction_no: params[:id])
              withdraw.cancel!
              present withdraw, with: Entities::Payment::Withdraw
            end
          end
        end
      end
    end
  end
end
