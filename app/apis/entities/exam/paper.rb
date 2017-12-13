module Entities
  module Exam
    class Paper < Grape::Entity
      expose :id
      expose :name
      expose :duration
      expose :topics_count
      expose :grade_category
      expose :subject
      expose :price
      expose :users_count
      expose :status
      expose :score
      expose :type
      expose :created_at
      expose :updated_at
      expose :published_at
    end
  end
end
