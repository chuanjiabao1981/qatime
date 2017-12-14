module Entities
  module Exam
    class Result < Grape::Entity
      expose :id
      expose :paper, using: Entities::Exam::Paper
    end
  end
end
