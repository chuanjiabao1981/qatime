module Entities
  module Exam
    class Category < Grape::Entity
      expose :id
      expose :paper_id
      expose :name
      expose :description
      expose :duration
      expose :read_time
      expose :play_times
      expose :interval_time
      expose :waiting_time
      expose :topics_count
      expose :score
      expose :created_at
      expose :updated_at
      expose :type
      expose :topics, using: Entities::Exam::Topic
    end
  end
end
