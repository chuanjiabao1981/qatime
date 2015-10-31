class ActionRecord < ActiveRecord::Base
  belongs_to :operator,class_name: User
  belongs_to :actionable,polymorphic: true

  validates_presence_of :operator

  self.per_page     = 10
end
