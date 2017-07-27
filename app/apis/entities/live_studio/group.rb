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
      expose :view_tickets_count
      expose :events_count
      expose :start_at
      expose :end_at
      expose :objective
      expose :suit_crowd
      expose :description
    end
  end
end
