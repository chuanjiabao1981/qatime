module QaComment
  extend ActiveSupport::Concern
  included do
    has_many  :comments, lambda { order 'created_at asc' } , {as: :commentable,dependent: :destroy} do
      def build(attributes={})
        if defined? proxy_association.owner.customized_course_id  and proxy_association.owner.customized_course_id
          attributes[:customized_course_id]        = proxy_association.owner.customized_course_id
        end
        super attributes
      end
    end
  end
end