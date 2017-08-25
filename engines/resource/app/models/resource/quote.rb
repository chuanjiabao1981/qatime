module Resource
  class Quote < ActiveRecord::Base
    belongs_to :file, counter_cache: true
    belongs_to :quoter, polymorphic: true
  end
end
