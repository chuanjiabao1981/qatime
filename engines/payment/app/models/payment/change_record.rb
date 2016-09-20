module Payment
  class ChangeRecord < ActiveRecord::Base
    has_soft_delete

    belongs_to :cash_account
    belongs_to :billing
    belongs_to :target, polymorphic: true
    belongs_to :owner, polymorphic: true

  end
end
