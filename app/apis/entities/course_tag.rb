module Entities
  class CourseTag < Grape::Entity
    expose :name
    expose :taggings_count
  end
end
