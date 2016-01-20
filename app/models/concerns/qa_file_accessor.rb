module QaFileAccessor
  extend ActiveSupport::Concern

  included do
    has_many :qa_file_quoters, as: :file_quoter, class_name: "QaFileQuoter"
    has_many :qa_files, through: :qa_file_quoters
    accepts_nested_attributes_for :qa_files
  end
end
