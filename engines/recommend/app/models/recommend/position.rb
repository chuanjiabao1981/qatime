module Recommend
  class Position < ActiveRecord::Base
    has_many :items
  end
end
