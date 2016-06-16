module LiveStudio
  class Channel < ActiveRecord::Base
    belongs_to :course

    has_many :streams
  end
end
