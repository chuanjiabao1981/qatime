# 设定 GEM_HOME
GEM_HOME = "/home/qatime/.rvm/gems/ruby-2.0.0-p481"

# 获取当前项目路径
require 'pathname'
path = Pathname.new(__FILE__).realpath # 当前文件完整路径
path = path.sub('/config/unicorn.rb', '')
APP_PATH = path.to_s

# 或直接填写
# APP_PATH = "/path_to_project/workspace/project_name"

# worker 数
worker_processes 4

# 项目目录，部署后的项目指向 current，如：/srv/project_name/current
working_directory APP_PATH

# we use a shorter backlog for quicker failover when busy
# 可同时监听 Unix 本地 socket 或 TCP 端口
listen "/tmp/qatime.sock", :backlog => 64
# 开启tcp 端口，可不使用 apache 或 nginx 做代理，直接本地：http://localhost:port
listen 8082, :tcp_nopush => true

# 如果为 REE，则添加 copy_on_wirte_friendly
# http://www.rubyenterpriseedition.com/faq.html#adapt_apps_for_cow
if GC.respond_to?(:copy_on_write_friendly=)
  GC.copy_on_write_friendly = true
end

# request 超时时间，超过此时间则自动将此请求杀掉，单位为秒
timeout 180

# unicorn master pid
# unicorn pid 存放路径
pid APP_PATH + "/tmp/pids/unicorn.pid"

# unicorn 日志
stderr_path APP_PATH + "/log/unicorn.stderr.log"
stdout_path APP_PATH + "/log/unicorn.stdout.log"

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end
