# 设定 GEM_HOME
#GEM_HOME = "/home/deploy/.rvm/gems/ruby-2.2.1@qatime"
# 不需要GEM_HOME的设定，因为unicorn命令都是通过bundle 执行所有的gemset都已经保证了
# rvm 2.2.1@qatime do bundle exec unicorn -c ..........

# 获取当前项目路径
APP_PATH = File.expand_path('../../', File.dirname(__FILE__))

# worker 数
worker_processes 4

# 项目目录，部署后的项目指向 current，如：/srv/project_name/current
working_directory "#{APP_PATH}/current"

# we use a shorter backlog for quicker failover when busy
# 可同时监听 Unix 本地 socket 或 TCP 端口
listen "#{APP_PATH}/shared/tmp/qatime.sock", :backlog => 64
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
pid APP_PATH + "/shared/tmp/pids/unicorn.pid"

# unicorn 日志
stderr_path APP_PATH + "/shared/log/unicorn.stderr.log"
stdout_path APP_PATH + "/shared/log/unicorn.stdout.log"

preload_app true

before_fork do |server, worker|
  ActiveRecord::Base.connection.disconnect! if defined?(ActiveRecord::Base)
  sleep(2)
  old_pid = "#{APP_PATH}/shared/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Send 'QUIT' signal to unicorn error!"
    end
  end

end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.establish_connection
end
