module LiveStudio
  class ReplayResourceJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      # Do something later
    end
  end
end
