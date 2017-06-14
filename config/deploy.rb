#load File.join(File.dirname(__FILE__),"recipes/nginx.rb")
load "config/recipes/nginx.rb"
load "config/recipes/qtfaststart.rb"
# config valid only for Capistrano 3.1
lock '3.8.1'

set :application, 'qatime'

set :repo_url, 'git@github.com:chuanjiabao1981/qatime.git'

# set :git_https_username,'chuanjiabao1981@gmail.com'
# set :git_https_password,'mgw198100'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/wechat.yml config/database.yml config/application.yml config/push.yml
                      config/vcloud.yml config/netease.yml config/oneapm.yml config/newrelic.yml config/app_apiclient_cert.p12 config/mp_apiclient_cert.p12 
                      config/alipay.yml config/alipay_rsa_public_key.pem config/qatime_rsa_private_key.pem
                      config/settings.yml config/global_settings.yml }

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads public/qrcode}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { rvm_bin_path: '~/.rvm/bin' }

# 注意这里要用lambda 延迟获取deploy_user的时间
set :unicorn_config_path,-> {"/home/#{fetch(:deploy_user)}/apps/qatime/current/config/unicorn.rb"}

SSHKit.config.command_map[:rake]  = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"
set :pty, true

# Default value for keep_releases is 5
set :keep_releases, 5

# this is for whenever
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }
# 设置生产还是预发环境 whenever只识别 environment
set :whenever_variables, ->{ "environment=#{fetch :stage}" }
set :whenever_roles, -> {:db}

namespace :deploy do
  task :restart do
    invoke 'unicorn:duplicate'
    # 直接停掉sidekiq, 依赖守护进程启动新的sidekiq
    # invoke "sidekiqctl stop #{shared_path}/tmp/pids/sidekiq.pid"
  end
  # desc "Copy static swf files"
  # task :copy_jwplayer do
  #   on roles(:app,:web, :db), in: :sequence, wait: 5 do
  #     ["public/assets/HLSProvider6.swf", "public/assets/jwplayer.flash.swf"].each do |path|
  #       execute "ln -fs #{shared_path}/#{path} #{release_path}/#{path}"
  #     end
  #   end
  # end

  desc "Create database before migrate"
  task :create_database do
    on roles(:db), in: :sequence, wait: 5 do
      execute "cd #{release_path} && ( RVM_BIN_PATH=~/.rvm/bin /usr/bin/env bundle exec rake db:create )"
      # execute "cd #{release_path} && (bundle exec rake db:create )"
    end
  end

  after :publishing, :restart
  after :finishing, 'deploy:cleanup'
  # after "updated", "deploy:copy_jwplayer"
end

namespace :qatime do
  desc "Transfer Qatime's secret conf to shared/config"
  task :upload_config do
    on roles(:all) do
      upload! "config/application.yml", "#{shared_path}/config/application.yml"
      upload! "config/database.yml","#{shared_path}/config/database.yml"
      upload! "config/wechat.yml","#{shared_path}/config/wechat.yml"
      upload! "config/vcloud.yml","#{shared_path}/config/vcloud.yml"
      upload! "config/netease.yml","#{shared_path}/config/netease.yml"
      upload! "config/oneapm.yml","#{shared_path}/config/oneapm.yml"
      upload! "config/newrelic.yml","#{shared_path}/config/newrelic.yml"
      upload! "config/alipay.yml","#{shared_path}/config/alipay.yml"
      upload! "config/settings.yml","#{shared_path}/config/settings.yml"
      upload! "config/push.yml","#{shared_path}/config/push.yml"
      upload! "config/app_apiclient_cert.p12","#{shared_path}/config/app_apiclient_cert.p12"
      upload! "config/mp_apiclient_cert.p12","#{shared_path}/config/mp_apiclient_cert.p12"
    end
  end
end
