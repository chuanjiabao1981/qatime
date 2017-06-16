set :use_sudo, true 

set :branch, 'QT-373'

set :deploy_user, 'qatime'
server '60.205.95.115', user: 'qatime', roles: %w{web app db}, primary:true

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/qatime"

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :testing

# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
set :unicorn_worker_count, 5

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false

# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

set :environment, :test

# set :sidekiq_monit_use_sudo, false
