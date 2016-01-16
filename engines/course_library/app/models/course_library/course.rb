module CourseLibrary
  class Course < ActiveRecord::Base
    validates_presence_of :title, :description
    belongs_to :directory                                         
    has_one :video_quoter, as: :file_quoter, class_name: "VideoQuoter"
    has_one :video, through: :video_quoter
    has_many :qa_file_quoters, as: :file_quoter, class_name: "QaFileQuoter"
    has_many :qa_files, through: :qa_file_quoters                 
    has_many :picture_quoters, as: :file_quoter, class_name: "PictureQuoter"
    has_many :pictures, through: :picture_quoters
    has_many :homeworks

    has_many :publications

    accepts_nested_attributes_for :publications
  end
end
