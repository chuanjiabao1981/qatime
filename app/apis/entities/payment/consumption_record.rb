module Entities
  module Payment
    class ConsumptionRecord < ChangeRecord
      expose :target_type do |record|
        record.target.is_a?(Payment::Order) ? record.target.product.model_name.human : record.target.model_name.human
      end
    end
  end
end
