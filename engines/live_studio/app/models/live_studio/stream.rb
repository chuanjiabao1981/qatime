module LiveStudio
  class Stream < ActiveRecord::Base
    has_soft_delete

    belongs_to :channel
  end
end
