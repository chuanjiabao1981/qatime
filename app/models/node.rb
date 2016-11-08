class Node < ApplicationRecord

  has_many   :topics  ,:dependent => :destroy
  has_many   :courses ,:dependent => :destroy
  belongs_to :section

  validates_presence_of :name, :summary, :section
end
