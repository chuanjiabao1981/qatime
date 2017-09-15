module Entities
  module LiveStudio
    class Question < Task
      expose :body
      expose :answer, using: Entities::LiveStudio::Answer # 回答
    end
  end
end
