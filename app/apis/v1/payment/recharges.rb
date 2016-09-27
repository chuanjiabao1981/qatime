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

              # 根据日期查询记录
              def query_by_date(chain)
                chain = chain.where("created_at > ?", params[:start_date]) if params[:start_date].present?
                chain = chain.where("created_at > ?", params[:end_date]) if params[:end_date].present?
                chain
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
          end
        end
      end
    end
  end
end
