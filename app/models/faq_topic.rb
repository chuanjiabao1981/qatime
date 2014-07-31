class FaqTopic < ActiveRecord::Base
  has_many :faqs
  belongs_to :user
end