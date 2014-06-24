#load File.join(File.dirname(__FILE__),"recipes/nginx.rb")
load "config/recipes/nginx.rb"
# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'qatime'
set :deploy_user, 'qatime'

set :scm, :git
set :repo_url, 'git@github.com:jesical516/qatime.git'


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
set :linked_files, %w{config/database.yml config/application.yml public/assets/HLSProvider6.swf public/assets/jwplayer.flash.swf }

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :rvm_ruby_version, '2.0.0-p481'
set :default_env, { rvm_bin_path: '~/.rvm/bin' }

set :unicorn_config_path, "/home/#{fetch(:deploy_user)}/apps/qatime/current/config/unicorn.rb"

SSHKit.config.command_map[:rake]  = "#{fetch(:default_env)[:rvm_bin_path]}/rvm ruby-#{fetch(:rvm_ruby_version)} do bundle exec rake"
set :pty, true

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do
  task :restart do
    invoke 'unicorn:restart'
  end

  desc "Copy static swf files"
  task :copy_jwplayer do
    on roles(:app,:web, :db), in: :sequence, wait: 5 do
      ["public/assets/HLSProvider6.swf", "public/assets/jwplayer.flash.swf"].each do |path|
        execute "ln -fs #{shared_path}/#{path} #{release_path}/#{path}"
      end
    end
  end

  after "updated", "deploy:copy_jwplayer"
end
