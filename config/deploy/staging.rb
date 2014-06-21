set :stage, :test
set :branch, 'develop'


server '42.121.55.211', user: 'qatime', roles: %w{web app db}, primary:true

set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/qatime"

# dont try and infer something as important as environment from
# stage name.
set :rails_env, :test

# number of unicorn workers, this will be reflected in
# the unicorn.rb and the monit configs
set :unicorn_worker_count, 5

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false