class QaFileQuoter < ActiveRecord::Base
  belongs_to :qa_file
  belongs_to :file_quoter, polymorphic: true
end
