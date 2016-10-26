module LiveStudio
  class Stream < ActiveRecord::Base
    has_soft_delete

    belongs_to :channel

    def use_for
      channel.use_for
    end
  end
end
