class Node < ActiveRecord::Base

  has_many   :topics,:dependent => :destroy
  belongs_to :section

  validates_presence_of :name, :summary, :section
end
