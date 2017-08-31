module LiveStudio
  # 专属课任务
  class Task < ActiveRecord::Base
    belongs_to :taskable, polymorphic: true
    belongs_to :user
  end
end
