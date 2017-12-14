module Entities
  module Exam
    class ResultDetail < Grape::Entity
      expose :id
      expose :paper, using: Entities::Exam::PaperDetail
    end
  end
end
