class FaqTopic < ApplicationRecord
  has_many :faqs
  belongs_to :user
end