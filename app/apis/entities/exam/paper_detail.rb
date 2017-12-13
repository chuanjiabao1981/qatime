module Entities
  module Exam
    class PaperDetail < Paper
      expose :categories, using: Entities::Exam::Category
    end
  end
end
