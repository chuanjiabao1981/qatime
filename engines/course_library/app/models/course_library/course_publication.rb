module CourseLibrary
  class CoursePublication < ActiveRecord::Base
    include DirtyAssociations


    belongs_to :course
    belongs_to :customized_course

    has_one  :customized_tutorial,:dependent => :destroy
    has_many :homework_publications,:dependent => :destroy

    has_many :homeworks,through: :homework_publications

    monitor_association_changes :homework_publications


    validates_uniqueness_of :customized_course_id ,scope: :course_id
    validates_presence_of :customized_course



    def homework_ids=(ids)
      puts self.homework_ids
      puts ids
      super(ids)
    end

    def homework_publication_ids=(ids)
      puts "111111----#{ids}"
      super(ids)
    end
  end
end
