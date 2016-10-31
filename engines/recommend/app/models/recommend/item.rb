module Recommend
  class Item < ActiveRecord::Base
    belongs_to :position
    belongs_to :target, polymorphic: true
    belongs_to :owner, polymorphic: true

    class_attribute :recomend_for
  end
  require_relative './teacher_item'
  require_relative './live_studio_course_item'
end
