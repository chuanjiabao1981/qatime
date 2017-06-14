class Comment < ApplicationRecord
  has_many :customized_course_comment_records, as: :actionable, dependent: :destroy do
    def build(attributes = {})
      if defined? proxy_association.owner.customized_course_id && proxy_association.owner.customized_course_id
        attributes[:customized_course_id] = proxy_association.owner.customized_course_id
      end
      super attributes
    end
  end

  belongs_to :commentable, polymorphic: true, counter_cache: true, inverse_of: :comments
  belongs_to :customized_course

  belongs_to :author, class_name: "User"
  validates_presence_of :content
  validates_presence_of :author

  def operator_id
    author_id
  end

  private

  after_create :__create_action_record
  def __create_action_record
    a = customized_course_comment_records.build(name: :create, operator_id: operator_id)
    a.save
  end
end
