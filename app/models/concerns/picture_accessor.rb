module PictureAccessor
  extend ActiveSupport::Concern

  included do
    has_many :picture_quoters, as: :file_quoter, class_name: "PictureQuoter"
    has_many :pictures, through: :picture_quoters
    accepts_nested_attributes_for :pictures, allow_destroy: true
  end
end
