class TagCategory < ActiveRecord::Base
  has_many :tags, class_name: 'ActsAsTaggableOn::Tag'
end
