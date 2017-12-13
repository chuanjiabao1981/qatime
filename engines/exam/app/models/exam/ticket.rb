module Exam
  class Ticket < ActiveRecord::Base
    enum status: { init: 0, active: 1 }

    belongs_to :student, class_name: '::Student'
    belongs_to :product, polymorphic: true
    belongs_to :payment_order, class_name: 'Payment::Order'
  end
end
