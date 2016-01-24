module CourseLibrary
  class Homework < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :course
    has_many :solutions
    has_many :qa_file_quoters, as: :file_quoter, class_name: "QaFileQuoter"
    has_many :qa_files, through: :qa_file_quoters
    has_many :picture_quoters, as: :file_quoter, class_name: "PictureQuoter"
    has_many :pictures, through: :picture_quoters

    has_many :exercises,class_name: "Exercise",foreign_key: "template_id"



  end
end
