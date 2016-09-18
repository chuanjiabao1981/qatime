module Payment
  class Transaction < ActiveRecord::Base
    belongs_to :user
  end
end
