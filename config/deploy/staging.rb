set :stage, :test
set :branch, 'develop'

set :deploy_user, 'qatime'
server '42.121.55.211', user: 'qatime', roles: %w{web app db}, primary:true
set :rvm_ruby_version, 'ruby-2.0.0'

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/qatime"

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :production

# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
set :unicorn_worker_count, 5

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false
# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

#role :app, %w{182.92.149.46}
#role :web, %w{182.92.149.46}
#role :db,  %w{182.92.149.46}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

#server '182.92.149.46', user: 'deploy', roles: %w{web app}, primary: true
