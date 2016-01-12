module TeachingProgram
  class Homework < ActiveRecord::Base
    # belongs to :course
    # has many :solutions
    # has many :qa_files, as: :qa_fileable
    # has many :picture, as: :imageable
  end
end
