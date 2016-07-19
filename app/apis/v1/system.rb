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
    end
  end
end
