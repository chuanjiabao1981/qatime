module Entities
  module LiveStudio
    class Group < Grape::Entity
      format_with(:local_timestamp, &:to_i)

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
      expose :objective
      expose :suit_crowd
      expose :description
      expose :icons do
        expose :refund_any_time do |group|
          group.refund_any_time?
        end
        expose :coupon_free do |group|
          group.coupon_free?
        end
        expose :cheap_moment do |group|
          group.cheap_moment?
        end
        expose :join_cheap do |group|
          group.join_cheap?
        end
        expose :free_taste do |group|
          group.free_taste?
        end
      end
      with_options(format_with: :local_timestamp) do
        expose :start_at
        expose :end_at
      end
    end
  end
end
