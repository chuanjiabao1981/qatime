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
        requires :category, type: String, desc: '应用分类', values: AppInfo.categories.keys
        requires :level, type: Integer, desc: '应用级别'
      end
      get 'check_update' do
        app_infos = ::AppInfo.running.where(category: params[:category]).where('level > ?',params[:level]).order(level: :desc)
        app_info = app_infos.first
        enforce =
          app_infos.select do |info|
            true if info.enforce && (info.enforce_level.blank? || info.enforce_level <= params[:level])
          end.present?
        present app_info,with: Entities::AppInfo, enforce: enforce
      end
    end
  end
end
