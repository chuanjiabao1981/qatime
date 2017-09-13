module Entities
  module LiveStudio
    class Answer < Task
      unexpose :title
      expose :body
    end
  end
end
