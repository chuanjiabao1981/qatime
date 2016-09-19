module Payment
  class Transaction < ActiveRecord::Base
    extend Enumerize

    belongs_to :user

    enumerize :source, in: { web: 0, app: 1 }
  end
end
