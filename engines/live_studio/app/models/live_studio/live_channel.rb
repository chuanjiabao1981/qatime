module LiveStudio
  class LiveChannel < ActiveRecord::Base
    belongs_to :course
  end
end
