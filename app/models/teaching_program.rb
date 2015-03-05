class TeachingProgram < ActiveRecord::Base

  validates_presence_of :name, :category, :grade, :content, :subject
  validates_uniqueness_of :name ,scope: [:category, :subject]

end
