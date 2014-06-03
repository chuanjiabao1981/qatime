class StudentJoinGroupRecord < ActiveRecord::Base
  belongs_to :student,:counter_cache => :joined_groups_count
  belongs_to :group,:counter_cache => :joined_students_count
end
