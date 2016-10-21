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

            desc '提交提现申请' do
              headers 'Remember-Token' => {
                description: 'RememberToken',
                required: true
              }
            end
            params do
              requires :amount, type: Float, desc: '提现金额'
              requires :pay_type, type: String, desc: '提现方式', values: %w(bank alipay)
              requires :account, type: String, desc: '账号'
              requires :name, type: String, desc: '姓名'
              requires :verify, type: String, desc: '验证码'
            end
            post 'withdraws' do
              captcha_manager = UserService::CaptchaManager.new(@user.login_mobile)
              captcha = captcha_manager.captcha_of(:withdraw_cash)
              raise(APIErrors::CaptchaError) if params[:verify] != captcha
              raise(APIErrors::WithdrawExisted) if @user.payment_withdraws.init.present?
              withdraw = @user.payment_withdraws.new({amount: params[:amount], pay_type: params[:pay_type]}.merge(status: :init))
              unless withdraw.save
                raise ActiveRecord::RecordInvalid, withdraw
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
