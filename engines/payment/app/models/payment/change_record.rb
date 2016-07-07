module Payment
  class ChangeRecord < ActiveRecord::Base
    has_soft_delete

    belongs_to :cash_account
    belongs_to :billing

    def target
      billing.try(:target)
    end
  end
end
