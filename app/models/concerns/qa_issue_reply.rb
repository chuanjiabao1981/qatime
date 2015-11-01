module QaIssueReply
  extend ActiveSupport::Concern
  included do
    validates :content, length: {minimum: 5},on: :create
  end



end