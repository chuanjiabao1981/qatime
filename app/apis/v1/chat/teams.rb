module V1
  # 聊天
  module Chat
    # 群组
    class Teams < V1::Base
      namespace "chat" do
        before do
          authenticate!
        end
        namespace :users do
          route_param :user_id do
            helpers do
              def auth_params
                @user ||= ::User.find(params[:user_id])
              end
            end

            resource :teams do
              desc '我加入的群组' do
                headers 'Remember-Token' => {
                  description: 'RememberToken',
                  required: true
                }
              end
              params do
                requires :user_id, type: Integer, desc: '用户ID'
              end
              get '' do
                teams = @user.chat_account.teams
                present teams, with: Entities::Chat::team
              end
            end
          end
        end
      end
    end
  end
end
