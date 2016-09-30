module V1
  # 系统消息
  class Notifications < Base
    before do
      authenticate!
    end

    helpers do
      def auth_params
        @notification = ::Notification.find(params[:id])
        @user = @notification.receiver
      end
    end

    namespace :users do
      route_param :user_id do
        helpers do
          def auth_params
            @user = ::User.find(params[:user_id])
          end
        end

        desc '消息列表' do
          headers 'Remember-Token' => {
            description: 'RememberToken',
            required: true
          }
        end
        params do
          requires :user_id, type: Integer, desc: 'ID'
          optional :page, type: Integer, desc: '页码'
        end
        get 'notifications' do
          notifications = @user.notifications.includes([:notificationable, :from]).paginate(page: params[:page])
          present notifications, with: Entities::Notification
        end
      end
    end

    resource :notifications do
      desc '标记通知已读' do
        headers 'Remember-Token' => {
          description: 'RememberToken',
          required: true
        }
      end
      params do
        requires :id, type: Integer, desc: 'ID'
      end
      put '/:id/read' do
        @notification.read
      end
    end
  end
end
