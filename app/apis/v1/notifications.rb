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

        desc '通知设置信息' do
          headers 'Remember-Token' => {
            description: 'RememberToken',
            required: true
          }
        end
        params do
          requires :user_id, type: Integer, desc: 'ID'
        end
        get 'notifications/settings' do
          @setting = NotificationSetting.find_by(owner: @user) || NotificationSetting.default
          present @setting, with: Entities::NotificationSetting
        end

        desc '更新通知设置' do
          headers 'Remember-Token' => {
            description: 'RememberToken',
            required: true
          }
        end
        params do
          requires :user_id, type: Integer, desc: 'ID'
          requires :notice, type: Integer, desc: '是否接收系统通知', values: [0, 1]
          requires :email, type: Integer, desc: '是否接收邮件通知', values: [0, 1]
          requires :message, type: Integer, desc: '是否接收短信通知', values: [0, 1]
          requires :before_hours, type: Integer, desc: '提前时间 小时'
          requires :before_minutes, type: Integer, desc: '提前时间 分钟'
        end
        put 'notifications/settings' do
          @setting = NotificationSetting.find_or_create_by(owner: @user, key: 'live_studio/course')
          @setting.update_attributes(notice: params[:notice],
                                     email: params[:email],
                                     message: params[:message],
                                     before_hours: params[:before_hours],
                                     before_minutes: params[:before_minutes])
          present @setting, with: Entities::NotificationSetting
        end

        desc '批量标记通知已读' do
          headers 'Remember-Token' => {
            description: 'RememberToken',
            required: true
          }
        end
        params do
          requires :ids, type: Array[Integer], coerce_with: ->(val) { val.split(/[\s,-]+/) }, desc: '通知ID列表用空格隔开'
        end
        put '/notifications/batch_read' do
          @user.notifications.where(id: params[:ids]).update_all(read: true)
          @user.notifications.where(id: params[:ids]).map {|n| [n.id, n.read] }
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
        @notification.read!
      end
    end
  end
end
