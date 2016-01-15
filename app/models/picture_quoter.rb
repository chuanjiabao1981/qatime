class PictureQuoter < ActiveRecord::Base
  belongs_to :picture
  belongs_to :file_quoter, polymorphic: true
end
