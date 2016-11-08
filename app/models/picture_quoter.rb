class PictureQuoter < ApplicationRecord
  belongs_to :picture
  belongs_to :file_quoter, polymorphic: true
end
