module Entities
  module Payment
    class ConsumptionRecord < Grape::Entity
      expose :id
      expose :amount
      expose :change_type
      expose :created_at do |record|
        I18n.localize record.created_at, format: :short
      end
      expose :target_type do |record|
        record.target.is_a?(Payment::Order) ? record.target.product.model_name.human : record.target.model_name.human
      end
    end
  end
end
