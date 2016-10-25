module Payment
  class Billing < ActiveRecord::Base
    belongs_to :target, polymorphic: true

    has_many :change_records

    belongs_to :parent, class_name: Billing
    has_many :sub_billings, class_name: Billing, foreign_key: "parent_id"
  end
end
