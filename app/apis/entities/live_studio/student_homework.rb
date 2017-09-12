module Entities
  module LiveStudio
    class StudentHomework < Task
      expose :correction, using: Entities::LiveStudio::Correction # 批改
      expose :homework, using: Entities::LiveStudio::Homework # 作业
    end
  end
end
