module Entities
  module Payment
    class EarningRecord < ChangeRecord
      expose :target_type do |record|
        record.target.model_name.human
      end
      expose :target_id
    end
  end
end
