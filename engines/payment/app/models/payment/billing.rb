module Payment
  class Billing < ActiveRecord::Base
    belongs_to :target, polymorphic: true

    has_many :change_records

    belongs_to :parent, class_name: Billing
    has_many :sub_billings, class_name: Billing, foreign_key: "parent_id"

    has_many :billing_items

    belongs_to :from_user, class_name: User
  end
end
