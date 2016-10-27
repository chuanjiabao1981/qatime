module Recommend
  class Item < ActiveRecord::Base
    belongs_to :position
    belongs_to :target, polymorphic: true
    belongs_to :owner, polymorphic: true
  end
end
