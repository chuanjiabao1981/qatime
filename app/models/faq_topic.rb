class FaqTopic < ActiveRecord::Base
  has_many :faqs
end