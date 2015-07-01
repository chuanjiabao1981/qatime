class CustomizedTutorial < ActiveRecord::Base

  belongs_to :teacher
  belongs_to :customized_course

  has_one    :video,:dependent => :destroy,as: :videoable

  validates_presence_of :title
end
