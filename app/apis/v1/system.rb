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
        requires :version, type: String, desc: '版本号'
        requires :platform, type: String, desc: '平台', values: ::Software.platform.values
      end
      get 'check_update' do
        category = ::Software.categories[params[:category].to_sym]
        platform = ::Software::PLATFORM_HASH[params[:platform].to_sym]
        binding.pry
        softwares = ::Software.where(category: category,platform: platform).where('version > ?', params[:version]).order(version: :desc)
        software = softwares.first
        enforce = softwares.select{|soft| true if soft.enforce}.present?
        present software,with: Entities::Software, enforce: enforce
      end
    end
  end
end
