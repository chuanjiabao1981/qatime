
server '182.92.149.46', user: 'deploy', roles: %w{web app db}, primary: true


set :branch, 'qatime-0.1.0'

set :deploy_user, 'deploy'
set :rvm_ruby_version, '2.2.1@qatime'

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/qatime"

###### for bundler
#设置这个使得bundler 把gem安装在相应的gemset下
#set :bundle_path, nil
###### end bundler


# dont try and infer something as important as environment from
# stage name.
set :rails_env, :production



# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
set :unicorn_worker_count, 5
set :unicorn_env , :production
set :unicorn_rack_env,:production

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

#role :app, %w{deploy@example.com}
#role :web, %w{deploy@example.com}
#role :db,  %w{deploy@example.com}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

