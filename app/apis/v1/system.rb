module V1
  # 系统环境
  class System < Base
    namespace :system, desc: '系统环境' do
      desc '接口健康状态'
      get 'health' do
        'OK'
      end

      desc '测试接口'
      params do
        requires :param
      end
      post 'test' do
        result = params.merge(remote_ip: headers['X-Real-Ip'])
        result
      end

      desc 'Ping'
      get 'ping' do
        'pong'
      end

      desc '检测是否需要升级'
      params do
        requires :category, type: String, desc: '应用分类', values: ::Software.categories.keys
        optional :version, type: String, desc: '版本号'
        requires :platform, type: String, desc: '平台', values: ::Software.platform.values
      end
      get 'check_update' do
        category = ::Software.categories[params[:category].to_sym]
        platform = ::Software::PLATFORM_HASH[params[:platform].to_sym]
        softwares = ::Software.where(category: category,platform: platform)
        softwares = softwares.where('version > ?', params[:version]) if params[:version].present?
        software = softwares.order(version: :desc).first
        enforce = softwares.select{|soft| true if soft.enforce}.present?
        present software,with: Entities::Software, enforce: enforce
      end

      desc '上传用户设备信息'
      params do
        optional :user_id, type: Integer, desc: '用户id'
        optional :device_token, type: String, desc: '设备编号'
        optional :device_model, type: String, desc: '设备型号'
        optional :app_name, type: String, desc: '应用名称'
        optional :app_version, type: String, desc: '应用版本号'
      end
      post 'device_info' do
        @user_device = UserDevice.find_or_create_by!(token: params[:device_token],app_name: params[:app_name])
        @user_device.update(user_id: params[:user_id],model: params[:device_model],app_version: params[:app_version])
        'ok'
      end
    end
  end
end
