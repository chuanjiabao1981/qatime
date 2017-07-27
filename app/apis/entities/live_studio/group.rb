module Entities
  module LiveStudio
    class Group < Grape::Entity
      expose :id
      expose :name
      expose :publicizes_url
      expose :subject
      expose :grade
      expose :status
      expose :teacher_name
      expose :price do |group|
        group.price.to_f.round(2)
      end
      expose :current_price
      expose :sell_type
      expose :view_tickets_count
      expose :events_count
      expose :closed_events_count
      expose :start_at
      expose :end_at
      expose :objective
      expose :suit_crowd
      expose :description
      expose :icons do
        expose :refund_any_time
        expose :coupon_free
        expose :cheap_moment
        expose :join_cheap
        expose :free_taste
      end
    end
  end
end
