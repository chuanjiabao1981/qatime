class Order < ActiveRecord::Base
  PAY_TYPE = {
    alipay: 0
  }.freeze

  belongs_to :user
  belongs_to :product, polymorphic: true
end
