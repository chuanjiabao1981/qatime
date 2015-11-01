module QaIssue
  extend ActiveSupport::Concern
  included do
    self.per_page =10
  end
end