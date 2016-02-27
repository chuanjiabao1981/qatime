require "dirty_associations"
require "acts_as_list"
module CourseLibrary
  class Engine < ::Rails::Engine

    isolate_namespace CourseLibrary
    # don't delete below
    # puts  config.autoload_paths
    # puts  config.eager_load_paths
  end
end
