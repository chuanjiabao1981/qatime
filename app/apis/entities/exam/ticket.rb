module Entities
  module Exam
    class Paper < Grape::Entity
      expose :id
      expose :created_at
      expose :updated_at
    end
  end
end
