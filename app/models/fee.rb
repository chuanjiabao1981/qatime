class Fee < ActiveRecord::Base
  belongs_to :customized_course
  belongs_to :feeable,polymorphic: true

end
