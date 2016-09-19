module Payment
  class Transaction < ActiveRecord::Base
    belongs_to :user

    enum source: [:web, :app]
  end
end
