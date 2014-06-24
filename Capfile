# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/rvm'
# Includes default deployment tasks
require 'capistrano/deploy'

# Includes tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.

require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano3/unicorn'

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }